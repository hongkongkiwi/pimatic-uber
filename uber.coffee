capitalizeFirstLetter = (string) =>
    return string.charAt(0).toUpperCase() + string.slice(1)

module.exports = (env) ->

  # ###require modules included in pimatic
  # To require modules that are included in pimatic use `env.require`. For available packages take
  # a look at the dependencies section in pimatics package.json

  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'

  Uber = Promise.promisifyAll require 'node-uber'
  _ = require 'underscore'
  fs = require 'fs'
  # express = require 'express'
  # url = require 'url'

  class UberPlugin extends env.plugins.Plugin

    # ####init()
    # The `init` function is called by the framework to ask your plugin to initialise.
    #
    # #####params:
    #  * `app` is the [express] instance the framework is using.
    #  * `framework` the framework itself
    #  * `config` the properties the user specified as config for your plugin in the `plugins`
    #     section of the config.json file
    #
    #
    init: (app, @framework, @config) =>
      ##env.logger.info("Hello World")

      deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass("UberPriceEstimateDevice", {
        configDef: deviceConfigDef.UberPriceEstimateDevice,
        createCallback: (config) => return new UberPriceEstimateDevice(config, @)
      })

  class UberPriceEstimateDevice extends env.devices.Device

    constructor: (@config, @plugin) ->
      @id = @config.id
      @name = @config.name
      @debug = @plugin.debug

      @start_longitude = @config.start_longitude
      @start_latitude = @config.start_latitude
      if @start_longitude is 0 or @start_latitude is 0
        env.logger.error "No Starting Longitude or Latitude set!"
      @end_longitude = @config.end_longitude
      @end_latitude = @config.end_latitude

      @updateInterval = @config.updateInterval
      if @updateInterval < 60
        env.logger.warn "We Recommend updateInterval Should Not be smaller than 60 seconds!"

      @showSurge = @config.showSurge
      @showETA = @config.showETA
      @showPrice = @config.showPrice

      @uber = new Uber {
        client_id: @plugin.config.clientId,
        client_secret: @plugin.config.clientSecret,
        server_token: @plugin.config.serverToken,
        redirect_uri: 'http://localhost:3000/api/callback',
        name: 'Pimatic Uber',
        language: @plugin.config.language,
        sandbox: @config.sandbox
      }

      cacheFile = __dirname + '/cache/uber-product-ids.json'

      # Check whether cache file exists
      try
        stats = fs.lstatSync cacheFile
        if stats.isDirectory()
          env.logger.error "Cache file is actually a directory!", cacheFile
        @products = require './cache/uber-product-ids'
      catch err
        if err.code is not 'ENOENT'
          if @debug
            env.logger.debug "Cache file does not exist!", cacheFile
        else
          env.logger.error err

      if @products?
        addGetter = (attributeName) =>
          @['_' + attributeName] = 0
          @['get' + (capitalizeFirstLetter attributeName)] = () => Promise.resolve(@['_' + attributeName])

        for k,v of @products
          if @showPrice
            attributeName = k + 'Price'
            @attributes[attributeName] = {
              description: v.description
              acronym: v.name + " Price"
              unit: v.currency
              type: "number"
            }
            addGetter attributeName
          if @showETA
            attributeName = k + 'ETA'
            @attributes[attributeName] = {
              description: "Time for closest " + v.name
              acronym: v.name + " ETA"
              unit: "mins"
              type: "number"
            }
            addGetter attributeName
          if @showSurge
            attributeName = k + 'Surge'
            @attributes[attributeName] = {
              description: "Surge Pricing Multiplier for " + v.name
              acronym: v.name + " Surge"
              unit: "x"
              type: "number"
            }
            addGetter attributeName

      # @uber.products.getAllForLocation @latitude, @longitude, (err, res) ->
      #   if err?
      #     return env.logger.error err
      #
      #   for k in res.products
      #     @attributes[k.product_id] = {
      #       description: "blah blah"
      #       acronym: "blah"
      #       unit: '$'
      #       type: "number"
      #     }
      #     this['get' + capitalizeFirstLetter(k.product_id)] = () -> Promise.resolve(1)

        if @showPrice or @showSurge
          @intervalTimerId = setInterval(@refreshPrices, (@updateInterval * 1000))
          @refreshPrices()

        if @showETA
          @intervalTimerId2 = setInterval(@refreshEstimates, @updateInterval * 1000)
          @refreshEstimates()
      super()

    destroy: () ->
      clearInterval @intervalTimerId if @intervalTimerId?
      clearInterval @intervalTimerId2 if @intervalTimerId2?
      super()

    refreshPrices: () =>
      if @debug
        env.logger.debug "refreshPrices()"
      @uber.estimates.getETAForLocation @start_latitude, @start_longitude, (err, res) =>
        if err
          if err.name is 'RateLimitError'
            return env.logger.info "Rate Limit Reached for getETAForLocation"
          else
            return env.logger.error err

        times = _.filter res.times, (time) => @products[time.product_id]

        if @debug
          env.logger.debug "Received Times from Uber", times

        for k in times
          attributeName =  k.product_id + 'ETA'
          @['_' + attributeName] = k.estimate / 60
          @emit attributeName, @['_' + attributeName]

    refreshEstimates: () =>
      if @debug
        env.logger.debug "refreshEstimates()"
      return @uber.estimates.getPriceForRoute @start_latitude, @start_longitude, @end_latitude, @end_longitude, (err, res) =>
        if err
          if err.name is 'RateLimitError'
            return env.logger.info "Rate Limit Reached for getPriceForRoute"
          else
            return env.logger.error err

        estimates = _.filter res.prices, (price) => @products[price.product_id]

        if @debug
          env.logger.debug "Received Estimates from Uber", estimates

        for k in estimates
          average = (k.low_estimate + k.high_estimate) / 2
          attributeName =  k.product_id + 'Price'
          @['_' + attributeName] = average
          @emit attributeName, @['_' + attributeName]
          attributeName =  k.product_id + 'Surge'
          @['_' + attributeName] = k.surge_multiplier
          @emit attributeName, @['_' + attributeName]

  # ###Finally
  # Create a instance of my plugin
  plugin = new UberPlugin
  # and return it to the framework.
  return plugin
