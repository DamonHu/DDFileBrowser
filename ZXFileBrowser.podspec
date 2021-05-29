Pod::Spec.new do |s|
s.name = 'ZXFileBrowser'
s.swift_version = '5.0'
s.version = '1.0.0'
s.license= { :type => "Apache-2.0", :file => "LICENSE" }
s.summary = 'iOS Sandbox file browser, iOS沙盒文件浏览器'
s.homepage = 'https://github.com/ZXKitCode/ZXFileBrowser'
s.authors = { 'ZXKitCode' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/ZXKitCode/ZXFileBrowser.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '11.0'
s.subspec 'core' do |cs|
	cs.resource_bundles = {
      'ZXFileBrowser' => ['pod/assets/**/*.png']
    }
    cs.source_files = "pod/*.swift", "pod/view/*.swift", "pod/vc/*.swift", "pod/model/*.swift", "pod/localizable/**/*"
    cs.dependency 'ZXKitUtil'
    cs.dependency 'SnapKit'
end
s.subspec 'zxkit' do |cs|
    cs.dependency 'ZXFileBrowser/core'
    cs.dependency 'ZXKitCore/core'
    cs.source_files = "pod/zxkit/*.swift"
end
s.default_subspecs = "core"
s.documentation_url = 'https://blog.hudongdong.com/ios/1169.html'
end
