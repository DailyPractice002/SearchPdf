//
//  ViewController.swift
//  SearchPdf
//
//  Created by macbook on 14/05/2021.
//

import UIKit
import PDFKit
 
class ViewController: UIViewController,SearchViewControllerDelegate,PDFViewDelegate {
    @IBOutlet weak var seravh: UIButton!
    var searchNavigationController: UINavigationController?
    let pdfViewGestureRecognizer = PDFViewGestureRecognizer()
     @IBOutlet weak var mypdfView:UIView!
    var documents = [PDFDocument]()
     var pdfDocument: PDFDocument?
    let pdfView = PDFView()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        refreshData()
        NotificationCenter.default.addObserver(self, selector: #selector(documentDirectoryDidChange(_:)), name: .documentDirectoryDidChange, object: nil)
       //  let path=Bundle.main.path(forResource: "c1", ofType: "pdf")
       // let url=URL(fileURLWithPath: path!)
        pdfView.frame =  mypdfView.bounds
        //pdfView = PDFView(frame: mypdfView.bounds)
        mypdfView.addSubview(pdfView)
        pdfView.autoScales = true
         pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal
        pdfView.usePageViewController(true, withViewOptions: [convertFromUIPageViewControllerOptionsKey(UIPageViewController.OptionsKey.interPageSpacing): 10])
        pdfView.addGestureRecognizer(pdfViewGestureRecognizer)
   
        pdfDocument = documents[0]
         pdfView.document = pdfDocument
   
      
        
         
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SearchViewController{
            viewController.pdfDocument = pdfDocument
            viewController.delegate = self
        }
    }
    @IBAction func searchbtn(_ sender: Any) {
       
        //self.performSegue(withIdentifier: "tc", sender: self)
        if let searchNavigationController = self.searchNavigationController {
            present(searchNavigationController, animated: true, completion: nil)
        } else if let navigationController = storyboard?.instantiateViewController(withIdentifier: String(describing: SearchViewController.self)) as? UINavigationController,
            let searchViewController = navigationController.topViewController as? SearchViewController {
            searchViewController.pdfDocument = pdfDocument
            searchViewController.delegate = self
            present(navigationController, animated: true, completion: nil)

            searchNavigationController = navigationController
        }
        
    }
     
    private func refreshData() {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let contents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        documents = contents.compactMap{ PDFDocument(url: $0) }

      
    }

    @objc func documentDirectoryDidChange(_ notification: Notification) {
        refreshData()
    }
     
    func searchViewController(_ searchViewController: SearchViewController, didSelectSearchResult selection: PDFSelection) {
        selection.color = .yellow
        pdfView.currentSelection = selection
        pdfView.go(to: selection)
       // showBars()
    }
    
}
fileprivate func convertFromUIPageViewControllerOptionsKey(_ input: UIPageViewController.OptionsKey) -> String {
    return input.rawValue
}
class PDFViewGestureRecognizer: UIGestureRecognizer {
    var isTracking = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        isTracking = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        isTracking = false
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        isTracking = false
    }
}

