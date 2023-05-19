//import SwiftUI
//import MapKit
//
//struct MapView: UIViewControllerRepresentable {
//    @Binding var selectedCoordinate: CLLocationCoordinate2D?
//
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let controller = MapViewController()
//        controller.delegate = context.coordinator
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(selectedCoordinate: $selectedCoordinate)
//    }
//
//    class Coordinator: NSObject, MapViewControllerDelegate {
//        @Binding var selectedCoordinate: CLLocationCoordinate2D?
//
//        init(selectedCoordinate: Binding<CLLocationCoordinate2D?>) {
//            _selectedCoordinate = selectedCoordinate
//        }
//
//        func didSelectCoordinate(_ coordinate: CLLocationCoordinate2D) {
//            selectedCoordinate = coordinate
//        }
//    }
//}
//
//protocol MapViewControllerDelegate: AnyObject {
//    func didSelectCoordinate(_ coordinate: CLLocationCoordinate2D)
//}
//
//class MapViewController: UIViewController {
//    weak var delegate: MapViewControllerDelegate?
//    let mapView = MKMapView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        mapView.delegate = self
//        mapView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(mapView)
//
//        NSLayoutConstraint.activate([
//            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            mapView.topAnchor.constraint(equalTo: view.topAnchor),
//            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
//        mapView.addGestureRecognizer(gestureRecognizer)
//    }
//
//    @objc private func mapTapped(_ gestureRecognizer: UITapGestureRecognizer) {
//        let location = gestureRecognizer.location(in: view)
//        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
//        delegate?.didSelectCoordinate(coordinate)
//    }
//}
//
//extension MapViewController: MKMapViewDelegate {
//    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//        // We're not doing anything here, but we need to implement this method
//        // in order for the mapView.delegate to be set correctly
//    }
//}
