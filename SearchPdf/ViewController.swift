//
//  ViewController.swift
//  SearchPdf
//
//  Created by macbook on 14/05/2021.
//

import UIKit
import PDFKit
var pdfDocument: PDFDocument?
class ViewController: UIViewController,SearchViewControllerDelegate {
    @IBOutlet weak var mypdfview:UIView!
    //@IBOutlet weak var pdfView: PDFView!
    
    var pdfDocument: PDFDocument?
    override func viewDidLoad() {
      //  let pdfView = PDFView(frame: mypdfview.bounds)
        super.viewDidLoad()
        pdfview()
         
        // Do any additional setup after loading the view.
    }
    func pdfview(){
        let path=Bundle.main.path(forResource: "c1", ofType: "pdf")
        let url=URL(fileURLWithPath: path!)
        let pdfView = PDFView(frame: mypdfview.bounds)
           pdfView.autoScales = true
           pdfView.displayMode = .singlePageContinuous
           pdfView.displayDirection = .vertical
         
           mypdfview.addSubview(pdfView)
           let pdfDocument = PDFDocument(url: url)
           pdfView.document=pdfDocument
    }
    func searchViewController(_ searchViewController: SearchViewController, didSelectSearchResult selection: PDFSelection) {
//        selection.color = .yellow
//        pdfView.currentSelection = selection
//        pdfView.go(to: selection)
      //  showBars()
    }

}

