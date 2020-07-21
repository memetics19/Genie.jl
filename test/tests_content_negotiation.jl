@safetestset "Content negotiation" begin

  @safetestset "Response type matches request type" begin
    @safetestset "Not found matches request type -- Content-Type -- custom HTML Genie page" begin
      using Genie
      using HTTP

      Genie.up()

      response = try
        HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Content-Type" => "text/html"])
      catch ex
        ex.response
      end

      @test response.status == 404
      @test occursin("Sorry, we can not find", String(response.body)) == true
      @test Dict(response.headers)["Content-Type"] == "text/html"

      response = try
        HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["COnTeNT-TyPe" => "text/html"])
      catch ex
        ex.response
      end

      @test response.status == 404
      @test occursin("Sorry, we can not find", String(response.body)) == true
      @test Dict(response.headers)["Content-Type"] == "text/html"

      Genie.down()
    end

    @safetestset "Not found matches request type -- Accept -- custom HTML Genie page" begin
      using Genie
      using HTTP

      Genie.up()

      response = try
        HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Accept" => "text/html"])
      catch ex
        ex.response
      end

      @test response.status == 404
      @test occursin("Sorry, we can not find", String(response.body)) == true
      @test Dict(response.headers)["Content-Type"] == "text/html"

      response = try
        HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["AcCePt" => "text/html"])
      catch ex
        ex.response
      end

      @test response.status == 404
      @test occursin("Sorry, we can not find", String(response.body)) == true
      @test Dict(response.headers)["Content-Type"] == "text/html"

      Genie.down()
    end

    @safetestset "Not found matches request type -- Content-Type -- custom JSON Genie handler" begin
      using Genie
      using HTTP

      Genie.up()

      response = try
        HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Content-Type" => "application/json"])
      catch ex
        ex.response
      end

      @test response.status == 404
      @test occursin("404 Not Found", String(response.body)) == true
      @test Dict(response.headers)["Content-Type"] == "application/json; charset=utf-8"

      response = try
        HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["CoNtEnt-TyPe" => "application/json"])
      catch ex
        ex.response
      end

      @test response.status == 404
      @test occursin("404 Not Found", String(response.body)) == true
      @test Dict(response.headers)["Content-Type"] == "application/json; charset=utf-8"

      Genie.down()
    end

    @safetestset "Not found matches request type -- Accept -- custom JSON Genie handler" begin
      using Genie
      using HTTP

      Genie.up()

      response = try
        HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Accept" => "application/json"])
      catch ex
        ex.response
      end

      @test response.status == 404
      @test occursin("404 Not Found", String(response.body)) == true
      @test Dict(response.headers)["Content-Type"] == "application/json; charset=utf-8"

      response = try
        HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["acCepT" => "application/json"])
      catch ex
        ex.response
      end

      @test response.status == 404
      @test occursin("404 Not Found", String(response.body)) == true
      @test Dict(response.headers)["Content-Type"] == "application/json; charset=utf-8"

      Genie.down()
    end

    @safetestset "Not found matches request type -- Content-Type -- custom text Genie handler" begin
      using Genie
      using HTTP

      Genie.up()

      response = try
        HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Content-Type" => "text/plain"])
      catch ex
        ex.response
      end

      @test response.status == 404
      @test occursin("404 Not Found", String(response.body)) == true
      @test Dict(response.headers)["Content-Type"] == "text/plain"

      response = try
        HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["conTeNT-tYPE" => "text/plain"])
      catch ex
        ex.response
      end

      @test response.status == 404
      @test occursin("404 Not Found", String(response.body)) == true
      @test Dict(response.headers)["Content-Type"] == "text/plain"

      Genie.down()
    end
  end;

  @safetestset "Not found matches request type -- Content-Type -- unknown content type get same response" begin
    using Genie
    using HTTP

    Genie.up()

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Content-Type" => "text/csv"])
    catch ex
      ex.response
    end

    @test response.status == 404
    @test occursin("404 Not Found", String(response.body)) == true
    @test Dict(response.headers)["Content-Type"] == "text/csv"

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["conTeNT-tYPE" => "text/csv"])
    catch ex
      ex.response
    end

    @test response.status == 404
    @test occursin("404 Not Found", String(response.body)) == true
    @test Dict(response.headers)["Content-Type"] == "text/csv"

    Genie.down()
  end

  @safetestset "Not found matches request type -- Accept -- unknown content type get same response" begin
    using Genie
    using HTTP

    Genie.up()

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Accept" => "text/csv"])
    catch ex
      ex.response
    end

    @test response.status == 404
    @test occursin("404 Not Found", String(response.body)) == true
    @test Dict(response.headers)["Content-Type"] == "text/csv"

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["accEPT" => "text/csv"])
    catch ex
      ex.response
    end

    @test response.status == 404
    @test occursin("404 Not Found", String(response.body)) == true
    @test Dict(response.headers)["Content-Type"] == "text/csv"

    Genie.down()
  end

  @safetestset "Custom error handler for unknown types" begin
    using Genie
    using HTTP

    Genie.up()

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Content-Type" => "text/csv"])
    catch ex
      ex.response
    end

    @test response.status == 404
    @test occursin("404 Not Found", String(response.body)) == true
    @test Dict(response.headers)["Content-Type"] == "text/csv"

    Genie.Router.error(error_message::String, ::Type{MIME"text/csv"}, ::Val{404}; error_info = "") = begin
      HTTP.Response(401, ["Content-Type" => "text/csv"], body = "Search CSV and you shall find")
    end

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["conTeNT-tYPE" => "text/csv"])
    catch ex
      ex.response
    end

    @test response.status == 401
    @test occursin("Search CSV and you shall find", String(response.body)) == true
    @test Dict(response.headers)["Content-Type"] == "text/csv"

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["accept" => "text/csv"])
    catch ex
      ex.response
    end

    @test response.status == 401
    @test occursin("Search CSV and you shall find", String(response.body)) == true
    @test Dict(response.headers)["Content-Type"] == "text/csv"

    Genie.down()
  end

  @safetestset "Custom error handler for known types" begin
    using Genie
    using HTTP

    Genie.up()

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Content-Type" => "application/json"])
    catch ex
      ex.response
    end

    @test response.status == 404
    @test occursin("404 Not Found", String(response.body)) == true
    @test Dict(response.headers)["Content-Type"] == "application/json; charset=utf-8"

    Genie.Router.error(error_message::String, ::Type{MIME"application/json"}, ::Val{404}; error_info = "") = begin
      HTTP.Response(401, ["Content-Type" => "application/json"], body = "Search CSV and you shall find")
    end

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["conTeNT-tYPE" => "application/json"])
    catch ex
      ex.response
    end

    @test response.status == 401
    @test occursin("Search CSV and you shall find", String(response.body)) == true
    @test Dict(response.headers)["Content-Type"] == "application/json"

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["accept" => "application/json"])
    catch ex
      ex.response
    end

    @test response.status == 401
    @test occursin("Search CSV and you shall find", String(response.body)) == true
    @test Dict(response.headers)["Content-Type"] == "application/json"

    Genie.down()
  end

  @safetestset "Order of accept preferences" begin
    using Genie
    using HTTP

    Genie.up()

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Accept" => "text/html, text/plain, application/json, text/csv"])
    catch ex
      ex.response
    end

    @test Dict(response.headers)["Content-Type"] == "text/html"

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Accept" => "text/plain, application/json, text/csv, text/html"])
    catch ex
      ex.response
    end

    @test Dict(response.headers)["Content-Type"] == "text/plain"

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Accept" => "application/json, text/csv, text/html, text/plain"])
    catch ex
      ex.response
    end

    @test Dict(response.headers)["Content-Type"] == "application/json"

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Accept" => "text/csv, text/html, text/plain, application/json"])
    catch ex
      ex.response
    end

    @test Dict(response.headers)["Content-Type"] == "text/html"

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Accept" => "text/csv, text/plain, application/json, text/html"])
    catch ex
      ex.response
    end

    @test Dict(response.headers)["Content-Type"] == "text/plain"

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Accept" => "text/csv, application/json, text/html, text/plain"])
    catch ex
      ex.response
    end

    @test Dict(response.headers)["Content-Type"] == "application/json"

    response = try
      HTTP.request("GET", "http://127.0.0.1:8000/notexisting", ["Accept" => "text/csv"])
    catch ex
      ex.response
    end

    @test Dict(response.headers)["Content-Type"] == "text/csv"

    Genie.down()
  end

end;