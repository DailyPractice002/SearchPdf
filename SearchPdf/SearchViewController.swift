//
//  SearchViewController.swift
//  SearchPdf
//
//  Created by Sikandar Ali on 14/05/2021.
//

import UIKit
import PDFKit

protocol SearchViewControllerDelegate: class {
    func searchViewController(_ searchViewController: SearchViewController, didSelectSearchResult selection: PDFSelection)
}

 
class SearchViewController: UIViewController , UISearchBarDelegate, PDFDocumentDelegate,UITableViewDelegate,UITableViewDataSource{
    var pdfDocument: PDFDocument?
    weak var delegate: SearchViewControllerDelegate?
    var searchBar = UISearchBar()
    
    @IBOutlet weak var mytableview:UITableView!
    deinit {
        pdfDocument?.cancelFindString()
        pdfDocument?.delegate = nil
    }

    
    var searchResults = [PDFSelection]()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        navigationItem.titleView = searchBar
//        let path = Bundle.main.path(forResource: "c1", ofType: "pdf")
//       let url   = URL(fileURLWithPath: path!)
//        pdfDocument = PDFDocument(url: url)
       
     
       
        mytableview.rowHeight = 88
        mytableview.register(UINib(nibName: String(describing: SearchTableViewCell.self), bundle: nil), forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pdfDocument?.delegate = nil
        pdfDocument?.cancelFindString()

        let searchText = searchBar.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        if searchText.count >= 3 {
            searchResults.removeAll()
            mytableview.reloadData()
            pdfDocument?.delegate = self
            pdfDocument?.beginFindString(searchText, withOptions: .caseInsensitive)
        }
    }

    func didMatchString(_ instance: PDFSelection) {
        searchResults.append(instance)
        mytableview.reloadData()
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

      func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Text"
    }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!  SearchTableViewCell

        let selection = searchResults[indexPath.row]

        let extendedSelection = selection.copy() as! PDFSelection
        extendedSelection.extendForLineBoundaries()

        let outline = pdfDocument?.outlineItem(for: selection)
        cell.section = outline?.label

        let page = selection.pages[0]
        cell.page = page.label

        cell.resultText = extendedSelection.string
        cell.searchText = selection.string

        return cell
    }

      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selection = searchResults[indexPath.row]
        searchBar.resignFirstResponder()
        delegate?.searchViewController(self, didSelectSearchResult: selection)
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)
    }
}

 
