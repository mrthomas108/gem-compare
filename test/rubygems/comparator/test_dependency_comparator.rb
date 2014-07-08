require 'rubygems/test_case'
require 'rubygems/comparator'

class TestDependencyComparator < Gem::TestCase
  def setup
    super

    options = { keep_all: true, log_all: true, no_color: true }
    versions = ['0.0.1', '0.0.2', '0.0.3', '0.0.4']

    @comparator = Gem::Comparator.new(options)

    Dir.chdir(File.expand_path('../../gemfiles', File.dirname(__FILE__))) do
      @comparator.options.merge!({ output: Dir.getwd })
      @comparator.compare_versions('lorem', versions)
    end

    @report = @comparator.report
  end
  
  def test_runtime_dependencies_comparison
    assert_equal 'DIFFERENT runtime dependencies:', @report['runtime_dependency'].header.data
    assert_equal 'DIFFERENT runtime dependencies:', @report['runtime_dependency'].lines(0)
    assert_equal '0.0.2->0.0.3:', @report['runtime_dependency']['0.0.2->0.0.3'].header.data
    assert_equal '0.0.2->0.0.3:', @report['runtime_dependency'].lines(1)
    assert_equal '* Added:', @report['runtime_dependency']['0.0.2->0.0.3']['added'].lines(0)
    assert_equal [], @report['runtime_dependency']['0.0.2->0.0.3']['deleted'].messages
    assert_equal [], @report['runtime_dependency']['0.0.2->0.0.3']['updated'].messages
    assert_equal ['rails [">= 4.0.0"] (runtime)'], @report['runtime_dependency']['0.0.2->0.0.3']['added'].lines(1)
    assert_equal '0.0.3->0.0.4:', @report['runtime_dependency']['0.0.3->0.0.4'].header.data
    assert_equal '0.0.3->0.0.4:', @report['runtime_dependency'].lines(4)
    assert_equal [], @report['runtime_dependency']['0.0.3->0.0.4']['added'].messages
    assert_equal [], @report['runtime_dependency']['0.0.3->0.0.4']['deleted'].messages
    assert_equal ['rails from: [">= 4.0.0"] to: [">= 4.1.0"]'], @report['runtime_dependency']['0.0.3->0.0.4']['updated'].lines(1)
  end
end