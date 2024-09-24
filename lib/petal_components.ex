defmodule PC do
  defmacro __using__(_) do
    quote do
      import PC.{
        Accordion,
        Alert,
        Avatar,
        Badge,
        Breadcrumbs,
        Button,
        Card,
        Container,
        Dropdown,
        Field,
        Form,
        Icon,
        Input,
        Link,
        Loading,
        Modal,
        Pagination,
        Progress,
        Rating,
        SlideOver,
        Table,
        Tabs,
        Typography,
        UserDropdownMenu,
        Menu
      }

      alias PC.HeroiconsV1
    end
  end
end
