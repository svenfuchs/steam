module Steam
  module Matchers
    module HtmlUnit
      class HasContent #:nodoc:
        def initialize(content)
          @content = content
        end

        def matches?(target)
          @target = target
          !!@target.locate_element(@content)
        end

        def failure_message
          "expected the following element's content to #{content_message}:\n#{squeeze_space(@target.page.body)}"
        end

        def negative_failure_message
          "expected the following element's content to not #{content_message}:\n#{squeeze_space(@target.page.body)}"
        end

        def squeeze_space(inner_text)
          (inner_text || '').gsub(/^\s*$/, "").squeeze("\n")
        end

        def content_message
          case @content
          when String
            "include \"#{@content}\""
          when Regexp
            "match #{@content.inspect}"
          end
        end
      end

      # Matches the contents of an HTML document with
      # whatever string is supplied
      def contain(content)
        HasContent.new(content)
      end

      # Asserts that the body of the response contain
      # the supplied string or regexp
      def assert_contain(content)
        hc = HasContent.new(content)
        assert hc.matches?(response_body), hc.failure_message
      end

      # Asserts that the body of the response
      # does not contain the supplied string or regepx
      def assert_not_contain(content)
        hc = HasContent.new(content)
        assert !hc.matches?(response_body), hc.negative_failure_message
      end
    end
  end
end