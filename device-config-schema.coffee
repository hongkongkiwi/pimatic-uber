module.exports = {
  title: "pimatic-uber device config schemas"
  UberPriceEstimateDevice: {
    title: "UberRouteDevice config options"
    type: "object"
    required: ["clientId","clientSecret","serverToken","latitude","longitude"]
    properties:
      updateInterval:
        description: "seconds delay between polls of pollution server"
        type: "number"
        default: 300
      clientId:
        description: "Uber Developer OAuth Client ID"
        type: "string"
      clientSecret:
        description: "Uber Developer OAuth Client Secret"
        type: "string"
      serverToken:
        description: "Uber Developer Server Token"
        type: "string"
      latitude:
        description: "Latitude where your Pimatic Server is located"
        type: "number"
      longitude:
        description: "Longitude where your Pimatic Server is located"
        type: "number"
      language:
        description: "What language to return the results in"
        type: "string"
        default: "en_US"
      sandbox:
        description: "Whether to use sandbox or live mode"
        type: "boolean"
        default: true
      productIds:
        description: "What product ids to include"
        type: "array"
  }
}
