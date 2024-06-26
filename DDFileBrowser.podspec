Pod::Spec.new do |s|
s.name = 'DDFileBrowser'
s.swift_version = '5.0'
s.version = '3.0.1'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = 'iOS Sandbox file browser, iOS沙盒文件浏览器'
s.homepage = 'https://github.com/DamonHu/DDFileBrowser'
s.authors = { 'DamonHu' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/DamonHu/DDFileBrowser.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '12.0'
s.subspec 'core' do |cs|
	cs.resource_bundles = {
      'DDFileBrowser' => ['pod/assets/**/*']
    }
    cs.source_files = "pod/*.swift", "pod/view/*.swift", "pod/vc/*.swift", "pod/model/*.swift"
    cs.dependency 'DDUtils/utils', '~>5.0.0'
    cs.dependency 'DDUtils/ui', '~>5.0.0'
    cs.dependency 'SnapKit', '~>5.0.0'
    cs.dependency 'HDHUD', '~>3.0.0'
end
s.default_subspecs = "core"
s.documentation_url = 'https://ddceo.com/blog/1295.html'
end
