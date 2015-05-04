module ProjectsHelper

  def fibonaci(n)
    # from https://gist.github.com/1007228
    (0..n).inject([1,0]) { |(a,b), _| [b, a+b] }[0]
  end

end
