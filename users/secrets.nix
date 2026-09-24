{ systemSops, ... }:
{
  secrets.anthropic_api_key = systemSops.secrets.anthropic_api_key.path;
  secrets.openai_api_key = systemSops.secrets.openai_api_key.path;
  secrets.google_generative_ai_api_key = systemSops.secrets.google_generative_ai_api_key.path;
  secrets.context7_api_key = systemSops.secrets.context7_api_key.path;
  secrets.hass_server = systemSops.secrets.hass_server.path;
  secrets.hass_token = systemSops.secrets.hass_token.path;

}
