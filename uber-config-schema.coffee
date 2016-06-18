module.exports = {
  title: "Uber Config Options"
  type: "object"
  required: ["clientId","clientSecret","serverToken"]
  properties:
    debug:
      description: "Debug mode. Writes debug messages to the pimatic log, if set to true."
      type: "boolean"
      default: false
    clientId:
      description: "Uber Developer OAuth Client ID"
      type: "string"
    clientSecret:
      description: "Uber Developer OAuth Client Secret"
      type: "string"
    serverToken:
      description: "Uber Developer Server Token"
      type: "string"
    language:
      description: "What language to return the results in"
      type: "string"
      default: "en_US"
}
