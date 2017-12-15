defmodule ShippingWeb.PageControllerTest do
  use ShippingWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Clerk"
    assert html_response(conn, 200) =~ "Shipping Ops Manager"
  end
end
