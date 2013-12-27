module Faraday
  class Adapter
    class NetHttpProgressBar < NetHttp
       Faraday.register_middleware(:adapter, net_http_progress_bar: NetHttpProgressBar)

      def perform_request(http, env)
        if :get == env[:method] and !env[:body]
          body = ""
          response = http.request_get(env[:url].request_uri, env[:request_headers]) do |res|
            response = res
            format = "%t: |%B| %p%% %c/%C %E" if length = res["Content-Length"]
            length = length ? length.to_i : nil
            progress_bar = ProgressBar.create(title: env[:url], total: length, format: format)

            res.read_body do |fragment|
              body << fragment
              progress_bar.progress += fragment.length
            end

            unless length
              progress_bar.total = body.size + 1
              progress_bar.finish
            end
          end
          response.body = body
          response
        else
          http.request create_request(env)
        end
      end
    end
  end
end
