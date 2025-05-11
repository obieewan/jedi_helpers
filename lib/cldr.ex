defmodule JediHelpers.Cldr do
  use Cldr,
    locales: ["en", "fr", "zh"],
    default_locale: "en",
    providers: [Cldr.Number, Money]
end
