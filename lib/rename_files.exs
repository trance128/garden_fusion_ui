defmodule Rename.Files do
  def run(from_regex, to_regex) do
    path = Path.join(["lib", "salad_ui"])

    File.ls!(path)
    |> Enum.each(fn file_name ->
      full_path = Path.join(path, file_name)
      updated = File.read!(full_path) |> String.replace(~r/#{from_regex}/, ~r/#{to_regex}/)
      File.write!(full_path, updated)
    end)

    IO.puts "Finished."
  end
end
