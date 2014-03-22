module MktoRest
  class Lead
    attr_reader :vars, :client
    def initialize(client, args)
      @vars = []
      @client = client
      args.each do |k,v|
        @vars << k
        self.instance_variable_set("@#{k}", v)
      end
    end

    def method_missing(mthsym, *args)
      if @vars.include? mthsym
        return self.instance_variable_get("@#{mthsym}") if args.empty?
        self.instance_variable_set("@#{mthsym}", args[0])
      end
    end

    def update(args, attr = :id)
      # the lead should be identified by the id not the email, but there's a bug 
      # soppting use from looking a lead up by id
      if attr == :id 
        @client.update self.id args
      elsif attr == :email
        @client.update self.email args
      end
    end

    def to_s
      @vars.collect { |k| "#{k}: #{self.send(k)}" }.join("/n")
    end
  end


end