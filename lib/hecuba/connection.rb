require 'cql'

module Hecuba
  class NoKeySpace < RuntimeError; end
  class CassandraNotRunning < RuntimeError; end

  class Connection
    def initialize host, keyspace
      begin
        @client = Cql::Client.connect(hosts: [host])
      rescue Ione::Io::ConnectionTimeoutError
        raise CassandraNotRunning, "Cassandra doesn't seem to be running on #{host}"
      end

      begin
        @client.use(keyspace)
      rescue Cql::QueryError
        raise NoKeySpace, "Keyspace #{keyspace} does not seem to exist"
      end
    end

  end
end
