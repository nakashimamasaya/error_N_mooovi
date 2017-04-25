class Scraping
  def self.movie_urls
    agent = Mechanize.new
    links=[]
    next_url =""
    while false do
      current_page = agent.get("http://review-movie.herokuapp.com"+ next_url)
      elements = current_page.search('.more-link')
      elements.each do |ele|
        links << ele[:href]
      end
      next_url = current_page.at('.next a')
      break unless next_url
      next_url = next_url[:href]
    end

    links.each do |link|
      get_product("http://review-movie.herokuapp.com"+link)
    end

  end

  def self.get_product(link)
    agent = Mechanize.new
    page = agent.get(link)

    title = page.search('.entry-title').inner_text
    image_url = page.at('.alignleft')[:src] if page.at('.alignleft')
    director = page.at('ul .director span').inner_text if page.at('ul .director span').inner_text
    detail = page.at('.entry-content p').inner_text if page.at('.entry-content p').inner_text
    open_date = page.at('ul .date span').inner_text if page.at('ul .date span').inner_text
    product = Product.where(title: title,image_url: image_url,director: director,detail: detail,open_date: open_date).first_or_initialize
    product.save
  end
end