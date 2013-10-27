module Selfie
  module DSL
    def snap_reference_dir
      asset = self.class.name.gsub(/Test$/,'').underscore
      asset_dir = File.join 'test','assets', asset
    end

    def make_report
      process_images
      File.write("snap.html", ERB.new(template).result(binding))
    end

    def open_report
      `open snap.html`
    end

    def process_images
      @diff = []
      @has_diff = Dir.exist? snap_reference_dir

      for snap in @snaps
        name = snap[:name]
        snap[:src]  = src  = "tmp/snap/current/#{name}.png"

        next unless @has_diff

        snap[:diff] = diff = "tmp/snap/current/#{name}_diff.png"
        snap[:ref]  = ref  = "#{snap_reference_dir}/#{name}.png"

        `compare #{ref} #{src} #{diff}`
        cmd = "convert #{ref} #{src} -compose Difference -composite -colorspace gray -format '%[fx:mean*100]' info:"

        snap[:psr] = (`#{cmd}`).strip.to_f
        snap[:changed] = snap[:psr] > snap[:threshold]

        @diff << snap if snap[:changed]
      end
    end

    def snap!(name, options={})

      name = ("%03d" % @film += 1) + "_#{name}"
      path = "tmp/snap/current/#{name}.png"

      snap = {name: name, url: current_url}
      snap[:threshold] = 0

      snap.merge!(options)

      @snaps << snap
      save_screenshot(path, :full => true)
    end

    def setup_selfie
      @snaps = []
      @film = 0
      `rm -rf tmp/snap/current`
      `mkdir -p tmp/snap/current`
    end

    def template
      <<-ERB

        <style>
          body {
            color:#4a4a4a;
            background-color:#efefef;
          }
          .paper  {
            border:1px solid #d0d0d0;
            font-family:helvetica;
            padding:20px;
            width:1500px;
            margin:50px auto; border:1px solid #efefef;
            border-radius:10px;
            background-color:white;
          }
          .no-ref {
            background-color:#efeeef;padding:10px; border-radius:5px;
          }
          p {
            word-wrap: break-word;
          }
          hr {
            border-color:#d0d0d0
          }
          .results img { border:10px solid #efefef; width:720px; }
          .failed     { color:#FF9999; }
          .img-failed img { border-color:#FF9999;}
          .logo {float:right;width:80px; border-radius:5px;width:60px;height:60px}
        </style>

        <title>Selfie results</title>
        <body>
        <div class='paper'>
        <img class='logo' title='Emile <3 you!' src='https://0.gravatar.com/avatar/aca8aad5245e144c9222102decb1776e&s=440'/>

        <h1 class='<%=(@diff.empty? ? "success" : "failed") %>'>Selfie - <%=(@diff.empty? ? "Lookin' good :)" : "Things changed") %></h1>

        <hr size=1/>

        <% unless @has_diff %>
          <div class='no-ref'>No reference images path defined in '<%=snap_reference_dir%>' -
          You can copy this: 'cp -R tmp/snap/current <%=snap_reference_dir%>'
          </div>
        <% end %>

        <div class='results'>
        <% unless @diff.empty? %>
          <h2>These <%=@diff.length%> snaps are different</h2>
          <% for snap in  @diff %>
            <div class='<%=(snap[:changed] ? "img-failed" : "img-success")%>'>
            <h3><%=snap[:name]%> (<%=snap[:psr]%>)</h3>
            <p><%=snap[:url]%></p>
            <p><%=snap[:note]%></p>
            <a href='<%=snap[:src]%>'><img src='<%=snap[:src]%>'/ ></a>
            <a href='<%=snap[:diff]%>'><img src='<%=snap[:diff]%>'/ ></a>
            </div>
          <% end %>
         <hr size=1/>
        <% end %>

        <h2>All snaps</h2>
        <% for snap in  @snaps %>
          <div class='<%=(snap[:changed] ? "img-failed" : "img-success")%>'>
          <h3><%=snap[:name]%> (<%=snap[:psr]%>)</h3>
          <p><%=snap[:url]%></p>
          <p><%=snap[:note]%></p>
          <a href='<%=snap[:src]%>'><img src='<%=snap[:src]%>'/ ></a>
          <a href='<%=snap[:diff]%>'><img src='<%=snap[:diff]%>'/ ></a>
          </div>
        <% end %>
        </div>
        </div>
        </body>
      ERB
    end
  end
end