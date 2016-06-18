pimatic-uber
=============

[Pimatic](http://pimatic.org) module to get [Uber](www.uber.com) ride info into your dashboard.

For now, the module just supports a Price and Time estimate from/to a fixed location you set. This plugin uses the node.js module [note-uber](https://www.github.com/hongkongkiwi/node-hongkongpollution) to interact with the [Uber API](https://developer.uber.com/docs).

## Using the Plugin

1. First, install the plugin `npm install pimatic-uber`
2. Then you need to [register as an Uber Developer](https://developer.uber.com/dashboard).
3. Once this is done, create a new app, it doesn't matter what you call it (I called mine 'Pimatic Uber'). You need to keep the Client Id, Client Secret and Server Token for the plugin configuration.

Since our app is for private use, we don't need to apply for permission from Uber.

## Plugin Configuration

You can load the plugin by editing your `config.json` to include:

```json
{
  "plugin": "uber",
  "clientId": "YOUR_CLIENT_ID",
  "clientSecret": "YOUR_CLIENT_SECRET",
  "serverToken": "YOUR_SERVER_TOKEN"
}
```

in the `plugins` Array.

## Device Configuration

Devices can be added by adding them to the `devices` Array in the config file. Set the `class` property to `UberPriceEstimateDevice`

For all device configuration options see the [device-config-schema](device-config-schema.coffee) file.

### Device examples

#### Uber Price Estimate Device

For getting your Latitude and Longitude you can use [latlong.net](http://www.latlong.net/).

Start Lat/Long is where you want your starting location to be (for example the location of your home).
End Lat/Long is where you want to take the ride to (for example your work location)

sandbox mode sets whether to use the testing or live uber server.

```json
{
  "id": "uber-price-estimate",
  "class": "UberPriceEstimateDevice",
  "name": "Uber Price Estimate",
  "start_longitude": -122.419416,
  "start_latitude": 37.774929,
  "end_longitude": -122.447906,
  "end_latitude": 37.723052,
  "sandbox": true
}
```

If you want to control which values are displayed, you can use the following:
```json
"showSurge": true,
"showETA": true,
"showPrice": true
```

### Creating a cache file

To work properly, the `UberPriceEstimateDevice` requires a cache file which includes some information on which Uber Product IDs you want to track. See below for an example of Product IDs from Hong Kong:

```json
{
  "3922df1b-b837-4e95-b8d7-14ec806d1243": {
    "name": "UberBlack",
    "description": "Closest UberBLACK",
    "currency": "HKD"
  },
  "e2300f8d-d24a-420e-afb8-0198c3989236": {
    "name": "UberX",
    "description": "UberX",
    "currency": "HKD"
  }
}
```

In future this part will be automatic.

## TODO

- Automatically create the cache file from available products
- Add ability to order a ride from the web interface (how can I do this?)
- OAuth Client Authorization, how to handle this from our web interface? Additionally we need a web-server for callbacks, how can this fit into pimatic?

## Contributing

Feel free to submit any pull requests or add functionality, I'm usually pretty responsive.

If you like the module, please consider donating some bitcoin or litecoin.

**Bitcoin**

![LNzdZksXcCF6qXbuiQpHPQ7LUeHuWa8dDW](http://i.imgur.com/9rsCfv5.png?1)

**LiteCoin**

![LNzdZksXcCF6qXbuiQpHPQ7LUeHuWa8dDW](http://i.imgur.com/yF1RoHp.png?1)
