# coding: UTF-8
rootdir = File.dirname(File.dirname(__FILE__))
$LOAD_PATH.unshift "#{rootdir}/lib"

if defined? Encoding
  Encoding.default_internal = 'UTF-8'
end

require 'test/unit'
require 'github/markdown'
require 'nokogiri'

def html_equal(html_a, html_b)
  assert_equal Nokogiri::HTML::DocumentFragment.parse(html_a).to_html,
    Nokogiri::HTML::DocumentFragment.parse(html_b).to_html
end

class GFMBasicTest < Test::Unit::TestCase
  Dir['test/fixtures/*.text', 'test/fixtures/Markdown_Redcarpet/**/*.text'].each do |md_file|
    dirname = File.dirname(md_file)
    markup = md_file.split('/').last.gsub(/\.text/, '').gsub(/(\s+)/, "_")
    define_method "test_#{dirname}_#{markup}" do
      source = File.read(md_file)

      expected_file = "#{dirname}/#{markup}.html"
      expected = File.read(expected_file).rstrip
      actual = GitHub::Markdown.render(source).rstrip

      if source != expected
        assert(source != actual, "#{markup} did not render anything")
      end

      diff = IO.popen("diff -u - #{expected_file}", 'r+') do |f|
        f.write actual
        f.close_write
        f.read
      end

      assert expected == actual, <<message
#{File.basename expected_file}'s contents don't match command output:
#{diff}
message
    end
  end

  def test_that_render_works
    GitHub::Markdown.to_html("Hello **world**!", :gfm)
  end

  def test_that_code_blocks_work
    GitHub::Markdown.to_html("~~~~~~~~~~\nhello world!\n~~~~~~~~~\n", :gfm)
  end

  # With GITHUB_MD_NESTING set to 32, we can handle up to 10 levels of list
  # nesting.  We do not go to 11.
  def test_nested_list
    items = [
      'Item 1',
      'Item 1a',
      'Item 1a1',
      'Item 1a1a',
      'Item 1a1a1',
      'Item 1a1a1a',
      'Item 1a1a1a1',
      'Item 1a1a1a1a',
      'Item 1a1a1a1a1',
      'Item 1a1a1a1a1a'
    ]

    pre = -3
    markdown = items.inject('') do |md, item|
      pre += 3
      md.concat(' '*pre + '+ ' + item + "\n")
    end

    html = GitHub::Markdown.render(markdown)
    parsed = Nokogiri::HTML::DocumentFragment.parse(html)

    items.inject(parsed) do |node, expected_item|
      child = node.xpath('.//ul/li')
      child_item = child.children.detect{|e| e.text?}.text.strip
      assert_equal expected_item, child_item
      node = child
    end
  end
end
