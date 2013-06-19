require 'spec_helper'

module LinkPreview
  describe Parser do
    let(:html) do
      %{<html>
          <head>
            <title>Foobar</title>
            <link rel='icon' href='/favicon.ico'>
          </head>
          <body>
            <p>Hello World</p>
            <a href='/foo' rel='nofollow'>Foo</a>
          </body>
        </html>
      }
    end
    let(:link_preview_parser) { Parser.new('http://foobar.com') }

    before  { HTTParty.stub(:get).and_return(html) }

    describe '#title' do
      context 'when title is nil' do
        let(:html) { '<html><head></head><body><p>Hello World</p></body></html>' }
        subject { link_preview_parser.title }

        it { should eq '' }
      end

      context 'when the page had title' do
        subject { link_preview_parser.title }

        it { should eq 'Foobar' }
      end
    end

    describe '#favicon' do
      context 'when had favicon' do
        subject { link_preview_parser.favicon }

        it { should eq 'http://foobar.com/favicon.ico' }
      end

      context 'when had other implementation of favicon' do
        let(:html) do
          %{<html>
              <head>
                <title>Google</title>
                <meta itemprop="image" content="/images/google_favicon_128.png">
              </head>
              <body>
                <p>Google Search</p>
              </body>
            </html>
          }
        end
        subject { Parser.new('http://google.com').favicon }

        it { should eq 'http://google.com/images/google_favicon_128.png' }
      end

      context 'when favicon is a link to other domain' do
        let(:html) do
          %{<html>
              <head>
                <title>Globo</title>
                <link rel="icon" href="http://s.glbimg.com/es/ge/static/globoesporte/img/favicon.png">
              </head>
              <body>
                <p>Google Search</p>
              </body>
            </html>
          }
        end
        subject { Parser.new('http://globoesporte.com').favicon }

        it { should eq 'http://s.glbimg.com/es/ge/static/globoesporte/img/favicon.png' }
      end

      context 'when do not had favicon' do
        let(:html) { '<html><head></head><body><p>Hello World</p></body></html>' }
        subject    { link_preview_parser.favicon }

        it { should eq '' }
      end
    end

    describe '#images' do
      subject { link_preview_parser.images }

      context 'when contain images from domain' do
        let(:html) do
          %{<html>
              <head>
                <title>Foobar</title>
              </head>
              <body>
                <p>Hello World</p>
                <img src='/foo.png' />
              </body>
            </html>
          }
        end

        it { should eq ['http://foobar.com/foo.png'] }
      end

      context 'when contain images from the request domain' do
        subject { Parser.new('trello.com').images }

        let(:html) do
          %{<html>
              <head>
                <title>Foobar</title>
              </head>
              <body>
                <p>Hello World</p>
                <img src='/foo.png' />
              </body>
            </html>
          }
        end

        it { should eq ['trello.com/foo.png'] }
      end

      context 'when contain images from other domain' do
        let(:html) do
          %{<html>
              <head>
                <title>Foobar</title>
              </head>
              <body>
                <p>Hello World</p>
                <img src='http://youtube.com/foo.png' />
              </body>
            </html>
          }
        end

        it { should eq ['http://youtube.com/foo.png'] }
      end

      context 'when contain images without src attribute' do
        let(:html) do
          %{<html>
              <head>
                <title>Foobar</title>
              </head>
              <body>
                <p>Hello World</p>
                <img />
              </body>
            </html>
          }
        end

        it { should eq [] }
      end
    end

    describe '#parse!' do
      context 'merge the properties' do
        let(:html) do
          %{<html>
              <head>
                <title>GitHub - Build software better, together.</title>
                <link rel='icon' href='/favicon.ico'>
              </head>
              <body>
                <p>Hello World</p>
                <img src="https://a248.e.akamai.net/assets.github.com/images/network.png?1355422571" />
              </body>
            </html>
          }
        end
        subject { Parser.new('github.com').parse! }

        it { should eq({ link: 'github.com', type: 'external', title: 'GitHub - Build software better, together.', favicon: 'github.com/favicon.ico', images: ['github.com/favicon.ico', 'https://a248.e.akamai.net/assets.github.com/images/network.png?1355422571'], description: ''}) }
      end

      context 'when raises exception trying to access the page' do
        subject { link_preview_parser.parse! }
        before { HTTParty.should_receive(:get).and_raise(Errno::ECONNREFUSED) }

        it { should eq({ error: 'Connection refused' }) }
      end

      context 'with open graph content' do
        let(:html) do
          %{
            <html>
              <head>
                <meta property="og:title" content="globoesporte.com">
                <meta property="og:type" content="website">
                <meta property="og:url" content="globoesporte.globo.com">
                <meta property="og:image" content="http://s.glbimg.com/es/ge/static/globoesporte/img/logo-globoesporte-facebook.jpg">
                <meta property="og:site_name" content="globoesporte.com">
                <meta property="og:description" content="globoesporte.com a melhor cobertura sobre o Futebol.">
              </head>
            </html>
          }
        end
        subject { Parser.new('globoesporte.com') }
        before { subject.parse! }

        its([:title]) { should eq 'globoesporte.com' }
        its([:description]) { should eq 'globoesporte.com a melhor cobertura sobre o Futebol.' }
        its([:images]) { should eq ['http://s.glbimg.com/es/ge/static/globoesporte/img/logo-globoesporte-facebook.jpg'] }
      end
    end

    describe '#valid?' do
      subject { Parser.new('http://github.com') }

      context 'when parse page' do
        before { subject[:link] = 'foo' }

        it { should be_valid }
      end

      context 'when raises error parsing page' do
        before { subject[:error] = 'SSL_connect state=SSLv3 bad ecpoint' }

        it { should_not be_valid }
      end
    end
  end
end