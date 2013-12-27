module Faraday
  class Adapter
    class NetHttpProgressBar < NetHttp
       Faraday.register_middleware(:adapter, net_http_progress_bar: NetHttpProgressBar)

      def perform_request(http, env)
        http.request create_request(env) unless :get == env[:method] and !env[:body]

        body = ""
        response = http.request_get(env[:url].request_uri, env[:request_headers]) do |res|
          progress_bar = setup_progress_bar(env, res)
          res.read_body do |fragment|
            body << fragment
            increment_progress_bar(progress_bar, fragment)
          end
          finish_progress_bar(progress_bar, content_length(res), body)
        end
        response.body = body
        response
      end

      private

      def setup_progress_bar(env, response)
        format = "%t: |%B| %p%% %c/%C %E" if content_length(response)
        ProgressBar.create(title: env[:url], total: content_length(response), format: format)
      end

      def content_length(response)
        response["Content-Length"] ? response["Content-Length"].to_i : nil
      end

      def increment_progress_bar(progress_bar, fragment)
        progress_bar.progress += fragment.length
      rescue # body length > content length 
        return
      end

      def finish_progress_bar(progress_bar, content_length, body)
        unless content_length
          progress_bar.total = body.length + 1
          progress_bar.finish
        end
      end
    end
  end
end
