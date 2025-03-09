module Jekyll
  class NoTrailingSlashGenerator < Generator
    safe true
    priority :low

    def generate(site)
      site.pages.each do |page|
        # Skip pages that already have no trailing slash
        next if page.url.nil? || page.url.empty? || page.url == '/' || !page.url.end_with?('/')
        
        # Create a new page with the same content but without trailing slash
        no_slash_url = page.url.chomp('/')
        
        # Create redirect from non-trailing slash to trailing slash
        redirect = PageWithoutAFile.new(site, site.source, File.dirname(no_slash_url), File.basename(no_slash_url))
        redirect.content = page.content
        redirect.data.merge!(page.data)
        redirect.data['permalink'] = no_slash_url
        
        site.pages << redirect
      end
    end
  end
end 