task default: %w[racc]

task :racc do
    sh "racc parser/parser.y -o parser/parser.rb"
end

task :book do
    sh "pdflatex -output-directory=tmp book_design/book.tex"
end

task :clean do
    sh "rm -f *.aux *.log *.out *.toc *.pdf tmp/*.aux tmp/*.out tmp/*.log tmp/*.aux tmp/*.toc"
end