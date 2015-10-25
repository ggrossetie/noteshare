# Seed data for the database for NSDocument
module NSDocument::Setup

  # NSDocument.seed_db clears
  def self.seed_db

    DocumentRepository.clear


    @article = DocumentRepository.create(NSDocument.new(title: 'Quantum Mechanics', author: 'Jared. Foo-Bar'))
    @section1 = DocumentRepository.create(NSDocument.new(title: 'Uncertainty Principle', author: 'Jared Foo-Bar', subdoc_refs: []))
    @section2 = DocumentRepository.create(NSDocument.new(title: 'Wave-Particle Duality', author: 'Jared Foo-Bar', subdoc_refs: []))
    @section3 = DocumentRepository.create(NSDocument.new(title: 'Matrix Mechanics', author: 'Jared Foo-Bar', subdoc_refs: []))
    @subsection =  DocumentRepository.create(NSDocument.new(title: "de Broglie's idea", author: 'Jared Foo-Bar', subdoc_refs: []))
    @subsubsection =  DocumentRepository.create(NSDocument.new(title: "Einstein's view", author: 'Jared Foo-Bar', subdoc_refs: []))


    @article.content = "= Quantum Mechanics\n\n:numbered:\nQuantum phenomena are weird!"
    @section1.content = "== Uncertainty Principle\n\nThe Uncertainty Principle invalidates the notion of trajectory"
    @section2.content = "== Wave-Particule Duality\n\nIt is, like, _so_ weird!"
    @section3.content = "== Matrix Mechanic\n\nIts all about the eigenvalues"
    @subsection.content = "=== de Broglie's idea\n\nHe was a count, and he firmly maintained that $a^2 + b^2 = c^2$"
    @subsection.content << "\n[env.theorem]\n--\nThere are infinitely many primes\n--\n\n"
    @subsubsection.content = "==== Einstein's view\n\nGod does not play with dice."

    @article.render_options[:format] = 'adoc-latex'
    @section1.render_options[:format] = 'adoc-latex'
    @section1.render_options[:format] = 'adoc-latex'
    @section2.render_options[:format] = 'adoc-latex'
    @section3.render_options[:format] = 'adoc-latex'
    @subsection.render_options[:format] = 'adoc-latex'
    @subsection.render_options[:format] = 'adoc-latex'
    @subsubsection.render_options[:format] = 'adoc-latex'


    DocumentRepository.persist @article
    DocumentRepository.persist @section1
    DocumentRepository.persist @section2
    DocumentRepository.persist @section3
    DocumentRepository.persist @subsection
    DocumentRepository.persist @subsubsection

    @section1.insert(0,@article)
    @section2.insert(1,@article)
    @section3.insert(2,@article)
    @subsection.add_to(@section2)
    @subsubsection.add_to(@subsection)

    DocumentRepository.all.each do |document|
      document.update_table_of_contents
      document.compile_with_render
    end

    DocumentRepository.all.count

  end


end