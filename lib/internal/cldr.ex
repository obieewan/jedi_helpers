defmodule JediHelpers.Internal.Cldr do
  @moduledoc false

  use Cldr,
    locales: ["en"],
    default_locale: "en",
    providers: [Cldr.Number, Money],
    generate_docs: false
end
