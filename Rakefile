task default: %w[racc]

task :racc do
    sh "racc parser/parser.y -o parser/parser.rb"
end

task :book do
    sh "cd book_design/; pdflatex -interaction=batchmode -output-directory=tmp book.tex; bibtex book; pdflatex -interaction=batchmode -output-directory=tmp book.tex; cd .."
end

task :clean do
    sh "rm -f *.aux *.log *.out *.toc *.pdf tmp/*.aux tmp/*.out tmp/*.log tmp/*.toc"
end