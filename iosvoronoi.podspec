Pod::Spec.new do |s|
  s.name             = 'iosvoronoi'
  s.version          = '0.1.2'
  s.summary          = 'A library for performing 2D voronoi tesselations in Objective C for iOS apps.'
  s.description      = <<-DESC
                                This is an iOS friendly, Objective-C version of Fortune's Algorithm based on Clay Heaton's Objective-C port. Using these classes, you can create Voronoi tessellations from sets of points in a cartesian plane. The library provides no graphical representation of the tessellation - it is merely an engine.

                                There are classes for fundamental Voronoi concepts (such as Cells, Sites, Edges, Vertices, etc) as well as classes related to Fortune's Algorithm (BeachSection, CircleEvent, etc).

                                Genealogy:

                                - Steven Fortune's initial C implementation can be found at his Bell Labs home page: http://ect.bell-labs.com/who/sjf/
                                - Raymond Hill's JavaScript implementation of Fortune's algorithm can be found here: https://github.com/gorhill/Javascript-Voronoi
                                - Clay Heaton's Objective-C port of Raymond Hill's implementation can be found here: https://github.com/clayheaton/objcvoronoi
                                - A detailed explanation of Fortune's algorithm can be found at Wikipedia: https://en.wikipedia.org/wiki/Fortune%27s_algorithm
                       DESC

  s.homepage         = 'https://github.com/DevRhys/iosvoronoi'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rhys D. Jones' => 'rhys@digitalcicadas.com' }
  s.source           = { :git => 'https://github.com/DevRhys/iosvoronoi.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'iosvoronoi/Classes/**/*.{h,m}'

  # s.resource_bundles = {
  #   'iosvoronoi' => ['iosvoronoi/Assets/*.png']
  # }

  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
