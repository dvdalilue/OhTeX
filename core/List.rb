class List

    attr_accessor :text,
                  :items,
                  :enumerate

    def initialize items=[]
        @items = items
        @text = ''
        @enumerate = false
    end

    def add e
        @items << e
    end

    def << e
        add e
    end

    def enumerate
        @enumerate = true
    end

    def itemize
        @enumerate = false
    end

    def items= e
        e.each do |x|
            if x.class.eql? Array
                add List::new(x)
            else
                add x
            end
        end
    end

    def to_tex ident=""
        tex = @text.clone
        list_type = 'itemize'
        list_type = 'enumerate' if @enumerate
        tex << "\n#{ident}\\begin{#{list_type}}\n"
        @items.each { |e| tex << "#{ident + "\t"}#{"\\item" if !e.class.eql? List} #{e.to_tex(ident + "\t")}\n" }
        tex << "#{ident}\\end{#{list_type}}\n"
        tex
    end
end