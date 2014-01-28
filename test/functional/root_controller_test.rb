require 'test_helper'

class RootControllerTest < ActionController::TestCase
  
  test "should get index" do
    stub_request(:get, "http://contentapi.dev/dapaas-home.json?role=dapaas").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
      to_return(:status => 200, :body => load_fixture('test-dapaas-content.json'), :headers => {})
    get :index
    assert_response :ok
  end
  
  test "should list news" do
    stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&role=dapaas&tag=news").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
      to_return(:status => 200, :body => load_fixture('news-list.json'), :headers => {})
      
    get :news_list, :section => "news"
    assert_response :ok
    
    doc = Nokogiri::HTML response.body
    
    assert_equal doc.search('#grid2 li').count, 1
    assert_equal doc.search('#grid2 li').first.search('h1')[0].content, "Test Dapaas content"
    assert_equal doc.search('#grid2 li').first.search('p.module-subheading')[0].content, "Alex Coley"
    assert_equal doc.search('#grid2 li').first.search('p.module-meta')[0].content, "9 December 2013"
    assert_equal doc.search('#grid2 li').first.search('p.category')[0].content, "news"
  end
  
  test "should list blogs" do
    stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&role=dapaas&tag=blog").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
      to_return(:status => 200, :body => load_fixture('blog-list.json'), :headers => {})
      
    get :blog_list, :section => "blog"
    assert_response :ok
    
    doc = Nokogiri::HTML response.body
    
    assert_equal doc.search('#grid2 li').count, 1
    assert_equal doc.search('#grid2 li').first.search('h1')[0].content, "Treating content as data"
    assert_equal doc.search('#grid2 li').first.search('p.module-subheading')[0].content, "Stuart Harrison"
    assert_equal doc.search('#grid2 li').first.search('p.module-meta')[0].content, "21 January 2014"
    assert_equal doc.search('#grid2 li').first.search('p.category')[0].content, "blog"
  end  
  
  test "should display news" do
    stub_request(:get, "http://contentapi.dev/test-dapaas-content.json?role=dapaas").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
      to_return(:status => 200, :body => load_fixture('test-dapaas-content.json'), :headers => {})
      
    get :news_article, :slug => "test-dapaas-content", :section => "news"
    assert_response :ok
    
    doc = Nokogiri::HTML response.body
      
    assert_equal doc.search('.page-title h1')[0].content, "Test Dapaas content"
    assert_equal doc.search('.article-body p')[0].content, "Bacon ipsum dolor sit amet capicola corned beef turkey, brisket sirloin swine jowl. Turducken pig pork shoulder bacon turkey drumstick shank shankle. Kevin cow chicken beef ribs jowl turkey brisket drumstick salami biltong shoulder. Jerky turducken prosciutto tenderloin hamburger shankle."
    assert_equal doc.search('.article-body p')[1].content, "Frankfurter biltong pastrami meatloaf, tenderloin kielbasa brisket flank. Pork swine venison shoulder ham cow short ribs, salami ribeye turkey. Shoulder leberkas kevin flank, filet mignon andouille brisket ball tip chuck corned beef. Ham hock leberkas hamburger salami beef ribs, flank pancetta cow. Pork chop hamburger ribeye spare ribs, capicola bacon cow chicken pig."
    assert_equal doc.search('.article-body p')[2].content, "Short loin shankle rump shank shoulder ground round salami doner boudin. Brisket chuck filet mignon capicola flank tongue leberkas pig shankle, pancetta shank tenderloin meatball. Turducken rump short loin tongue boudin ribeye biltong doner chuck leberkas. Short loin turkey fatback salami sausage."
    assert_equal doc.search('.article-body p')[3].content, "Shank salami flank cow pork belly pork chop ham hock. Bresaola swine ham meatball, turducken doner salami. Tongue turducken hamburger, beef sausage short ribs fatback. Tongue pork belly pastrami tail filet mignon chicken ham turkey drumstick."    
  end
  
  test "should display blogs" do
    stub_request(:get, "http://contentapi.dev/treating-content-as-data.json?role=dapaas").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
      to_return(:status => 200, :body => load_fixture('treating-content-as-data.json'), :headers => {})
      
    get :blog_article, :slug => "treating-content-as-data", :section => "blog"
    assert_response :ok
    
    doc = Nokogiri::HTML response.body
      
    assert_equal doc.search('.page-title h1')[0].content, "Treating content as data"
    assert_equal doc.search('.author').first.content, "Stuart Harrison"
    assert_equal doc.search('.date').first.content, "2014-01-21"
  end
  
  test "should list events" do
  test "should list events in chronological order" do
    stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&role=dapaas&tag=event").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
      to_return(:status => 200, :body => load_fixture('events-list.json'), :headers => {})
      
    get :events_list, :section => "events"
    assert_response :ok
    
    doc = Nokogiri::HTML response.body
    
    assert_equal doc.search('#grid2 li').count, 1
    assert_match /Dapaas test event/, doc.search('#grid2 li').first.search('h1.module-heading')[0].content
    assert_equal doc.search('#grid2 li').first.search('span.date')[0].to_s, "<span class=\"date\">Wednesday 25 December 2013<br>at  3:00PM</span>"
  end
  
  test "should display events" do
    stub_request(:get, "http://contentapi.dev/dapaas-test-event.json?role=dapaas").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
      to_return(:status => 200, :body => load_fixture('dapaas-test-event.json'), :headers => {})
      
    get :events_article, :slug => "dapaas-test-event", :section => "events"
    assert_response :ok
    
    doc = Nokogiri::HTML response.body
    
    assert_equal doc.search('.article-body h2')[0].content, "Dapaas test event"
    assert_equal doc.search('.article-body h3')[0].content, "Wednesday 25 December 2013,  3:00pm -  3:15pm"
    assert_match /<p>Bacon ipsum dolor sit amet hamburger fugiat jowl, reprehenderit filet mignon ut ad ham hock consectetur bresaola leberkas laborum pork drumstick. Incididunt ut laboris voluptate, velit aliquip dolor beef ribs strip steak short ribs. Beef meatloaf proident boudin nostrud. Jerky shank sed ullamco corned beef pork loin in.<\/p> <p>Ut turducken meatloaf pig mollit drumstick. Eiusmod andouille aute, pig turducken magna bacon cupidatat cow shank in prosciutto cillum hamburger esse. Ea jowl consequat drumstick adipisicing. Labore biltong ball tip eiusmod tempor, velit sed jerky ribeye cillum consectetur est sausage.<\/p> <p>Ham do id shank brisket corned beef. Veniam short loin consectetur, qui laborum hamburger consequat ea sausage ham hock venison brisket shankle minim nisi. Cow kevin non, pork loin sausage ham hock sint pork tri-tip officia est commodo consectetur occaecat enim. Quis dolore spare ribs biltong, rump andouille nisi jerky pancetta tri-tip chicken venison ullamco boudin. Beef tenderloin leberkas mollit excepteur officia anim.<\/p> <p>Anim pancetta ut salami labore nulla qui hamburger filet mignon chicken exercitation. Chicken tri-tip tempor enim. Ullamco chuck cupidatat pork loin, nulla ham boudin pastrami sint sirloin irure tempor minim. Ullamco exercitation id flank. Deserunt pancetta ball tip cupidatat kevin venison. Kielbasa sirloin adipisicing sunt hamburger spare ribs turducken pork.<\/p>/, doc.search('.article-body')[0].to_s.squish
  end
  
  test "should list partners" do
    stub_request(:get, "http://contentapi.dev/with_tag.json?include_children=1&role=dapaas&tag=partner").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
      to_return(:status => 200, :body => load_fixture('partners-list.json'), :headers => {})
      
    get :partners_list, :section => "partners"
    assert_response :ok
    
    doc = Nokogiri::HTML response.body
    
    assert_equal doc.search('#grid2 li').count, 1
    assert_equal "Open Data Institute (ODI)", doc.search('#grid2 li').first.search('h1.module-heading')[0].content
  end
  
  test "should display partners" do
    stub_request(:get, "http://contentapi.dev/odi-open-data-institute.json?role=dapaas").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
      to_return(:status => 200, :body => load_fixture('dapaas-test-partner.json'), :headers => {})
      
    get :partners_article, :slug => "odi-open-data-institute", :section => "partners"
    
    doc = Nokogiri::HTML response.body
    
    assert_equal doc.search('.article-body h2')[0].content, "Open Data Institute (ODI)"
    assert_equal doc.search('.article-body div p')[0].content.squish, "The Open Data Institute (ODI), was founded by Sir Tim Berners-Lee and Sir Nigel Shadbolt and launched officially in December 2012. As an independent, non-profit, non-partisan company, the ODI provides a catalyst for the evolution of an open data culture, creating economic, environmental and social value. The ODI works with government, the commercial, public, and not-for-profit sectors, in the UK and worldwide to unlock the supply of open data and build understanding of the benefits of doing so."
    assert_equal doc.search('.article-body div p')[1].content.squish, "Through an incubation programme for open data startups and a network of over 50 members, the ODI is stimulating the demand for open data in areas such as transparency and open innovation. By conducting research and contributing to policy, the ODI is developing and disseminating open data best practices, exemplified by the Open Data Certificates service, which provides a seal of approval for published data sets."
    assert_equal doc.search('.article-body div p')[2].content.squish, "Through a public training programme, the convening of world class experts from industry and academic, and the ongoing Open Data Challenge series, the ODI is building capability across a range of sectors and communities. Contributions from the ODI to wider initiatives, such as the Smart London board (exploring smart city solutions for London), ensure that open data delivers the greatest possible economic, environmental and social value."
  
    assert_equal doc.search('.article-body img.partner-logo')[0][:src], "http://bd7a65e2cb448908f934-86a50c88e47af9e1fb58ce0672b5a500.r32.cf3.rackcdn.com/uploads/assets/a9/b3/52a9b3dcd0d4624a8c000006/outline-solid-W-170px.png"
  
    assert_equal doc.search('.article-body ul')[0].search('li')[0].content, "Phone Number: 123456"
    assert_equal doc.search('.article-body ul')[0].search('li')[1].content, "Email Address: info@theodi.org"
    assert_equal doc.search('.article-body ul')[0].search('li')[1].search('a')[0][:href], "mailto:info@theodi.org"
    assert_equal doc.search('.article-body ul')[0].search('li')[2].content, "Website: http://theodi.org"
    assert_equal doc.search('.article-body ul')[0].search('li')[2].search('a')[0][:href], "http://theodi.org"
    assert_equal doc.search('.article-body ul')[0].search('li')[3].content, "Twitter: @UKODI"
    assert_equal doc.search('.article-body ul')[0].search('li')[3].search('a')[0][:href], "http://twitter.com/UKODI"
    assert_equal doc.search('.article-body ul')[0].search('li')[4].content, "Linkedin: http://linkedin.com/example"
    assert_equal doc.search('.article-body ul')[0].search('li')[4].search('a')[0][:href], "http://linkedin.com/example"
  end
  
  test "should display pages" do
    stub_request(:get, "http://contentapi.dev/test-dapaas-content.json?role=dapaas").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer overwritten on deploy', 'Content-Type'=>'application/json', 'User-Agent'=>'GDS Api Client v. 7.5.0'}).
      to_return(:status => 200, :body => load_fixture('dapaas-test-page.json'), :headers => {})
      
    get :page, :slug => "test-dapaas-content"
    assert_response :ok
    
    doc = Nokogiri::HTML response.body
    
    assert_equal doc.search('.page-title h1')[0].content, "Dapaas test page"
    assert_equal doc.search('.article-body p')[0].content, "Bacon ipsum dolor sit amet venison bacon pastrami, swine frankfurter rump filet mignon tri-tip beef ribs sirloin shankle sausage. Short loin ribeye pork corned beef capicola leberkas swine. Chuck ball tip shoulder frankfurter hamburger swine. Drumstick cow pastrami strip steak capicola meatball chicken swine ball tip doner. Shankle doner capicola meatball. Brisket drumstick capicola, jerky spare ribs andouille bacon short ribs tri-tip ball tip sirloin."
  end

end