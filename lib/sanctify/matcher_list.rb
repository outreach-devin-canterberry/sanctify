module Sanctify
  class ParserError < StandardError; end
  class MatcherList
    def initialize
      @matchers = DEFAULT_MATCHERS
    end

    def add(desc:, regex:)
      if desc.length.zero?
        raise ParserError, "Description must exist and be greater length than zero"
      end

      unless regex.is_a? Regexp
        raise ParserError, "Regex must be of type Regexp"
      end

      @matchers << { description: desc, regex: regex }
      @matchers
    end

    def each(&blk)
      @matchers.each &blk
    end

    DEFAULT_MATCHERS = [
      {
        description: "AWS Access Key ID",
        regex: /AKIA[0-9A-Z]{16}/
      },
      {
        description: "AWS Secret Key",
        regex: /\b(?<![A-Za-z0-9\/+=])(?=.*[\/&?=-@#$%\\^+])[A-Za-z0-9\/+=]{40}(?![A-Za-z0-9\/+=])\b/
      },
      {
        description: "SSH RSA Private Key",
        regex: /^-----BEGIN RSA PRIVATE KEY-----$/
      },
      {
        description: "X.509 Certificate",
        regex: /^-----BEGIN CERTIFICATE-----$/
      },
      {
        description: "Redis URL with Password",
        regex: /redis:\/\/[0-9a-zA-Z:@.\\-]+/
      },
      {
        description: "URL Basic auth",
        regex: /https?:\/\/[0-9a-zA-z_]+?:[0-9a-zA-z_]+?@.+?/
      },
      {
        description:"Google Access Token",
        regex: /ya29.[0-9a-zA-Z_\\-]{68}/
      },
      {
        description: "Google API",
        regex: /AIzaSy[0-9a-zA-Z_\\-]{33}/
      },
      {
        description: "Slack API",
        regex: /xoxp-\\d+-\\d+-\\d+-[0-9a-f]+/
      },
      {
        description: "Slack Bot",
        regex: /xoxb-\\d+-[0-9a-zA-Z]+/
      },
      {
        description: "Gem Fury v1",
        regex: /https?:\/\/[0-9a-zA-Z]+@[a-z]+\\.(gemfury.com|fury.io)(\/[a-z]+)?/
      },
      {
        description: "Gem Fury v2",
        regex: /https?:\/\/[a-z]+\\.(gemfury.com|fury.io)\/[0-9a-zA-Z]{20}/
      }
    ]
  end
end
