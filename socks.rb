require 'green_shoes'
require 'json'

def parse_style (styles)
    obj = {}
    styles.each do |style|
        case style[0]
        when "align"
            obj[:align] = style[1]
        when "angle"
            obj[:angle] = style[1]
        when "autoplay"
            obj[:autoplay] = style[1]
        when "bottom"
            obj[:bottom] = style[1]
        when "center"
            obj[:center] = style[1]
        when "curve"
            obj[:curve] = style[1]
        when "displace_left"
            obj[:displace_left] = style[1]
        when "emphasis"
            obj[:emphasis] = style[1]
        when "family"
            obj[:family] = style[1]
        when "fill"
            obj[:fill] = style[1]
        when "font"
            obj[:font] = style[1]
        when "height"
            obj[:height] = style[1]
        when "hidden"
            obj[:hidden] = style[1]
        when "justify"
            obj[:justify] = style[1]
        when "kerning"
            obj[:kerning] = style[1]
        when "leading"
            obj[:leading] = style[1]
        when "left"
            obj[:left] = style[1]
        when "margin"
            obj[:margin] = style[1]
        when "margin_bottom"
            obj[:margin_bottom] = style[1]
        when "margin_left"
            obj[:margin_left] = style[1]
        when "margin_left"
            obj[:margin_left] = style[1]
        when "margin_right"
            obj[:margin_right] = style[1]
        when "margin_top"
            obj[:margin_top] = style[1]
        when "radius"
            obj[:radius] = style[1]
        when "right"
            obj[:right] = style[1]
        when "rise"
            obj[:rise] = style[1]
        when "size"
            obj[:size] = style[1]
        when "stretch"
            obj[:stretch] = style[1]
        when "strikethrough"
            obj[:strikethrough] = style[1]
        when "stroke"
            obj[:stroke] = style[1]
        when "strokewidth"
            obj[:strokewidth] = style[1]
        when "top"
            obj[:top] = style[1]
        when "underline"
            obj[:underline] = style[1]
        when "variant"
            obj[:variant] = style[1]
        when "weight"
            obj[:weight] = style[1]
        when "width"
            obj[:width] = style[1]
        when "wrap"
            obj[:wrap] = style[1]
        end
    end    
    obj
end

def parse_slide (slide)
    slide.each do |element|
        style = {}
        if element.has_key?("styles")
            style = parse_style element["styles"]
        end

        case element["type"]
        when "banner"
            banner(element["data"], style)
        when "para"
            para(element["data"], style)
        when "image"
            image(element["data"], style)
        when "link"
            para(link(element["data"]), style)
        when "code"
            para(code(element["data"]), style)
        when "del"
            para(del(element["data"]), style)
        when "em"
            para(em(element["data"]), style)
        when "ins"
            para(ins(element["data"]), style)
        when "span"
            para(span(element["data"]), style)
        when "strong"
            para(strong(element["data"]), style)
        when "sub"
            para(sub(element["data"]), style)
        when "sup"
            para(sup(element["data"]), style)
        when "caption"
            caption(element["data"], style)
        when "inscription"
            inscription(element["data"], style)
        when "subtitle"
            subtitle(element["data"], style)
        when "title"
            title(element["data"], style)
        when "tagline"
            tagline(element["data"], style)
        when "video"
            video(element["data"], style)
        end
    end
end

puts "Socks v0.1"
if ARGV.length == 0
    puts "Error: No input files"
else
    filename = ARGV[0]
    puts "Reading #{ARGV[0]}..."
    json = File.read(filename)
    prs = JSON.parse(json)

    puts "Loading GUI..."

    @app = Shoes.app :title => prs["name"], :width => 800, :height => 600 do
        pos = 0

        margin = 0
        if prs.has_key?("margin")
            margin = prs["margin"]
        end

        flow :margin => margin do
            parse_slide prs["slides"][pos]
        end

        keypress do |k|
            if k == "Right"
                pos += 1
            elsif k == "Left"
                pos -= 1
            end

            if k == prs["slides"].length
                exit
            end

            @app.clear {
                flow :margin => margin do
                    parse_slide prs["slides"][pos]
                end
            }
        end
    end
end