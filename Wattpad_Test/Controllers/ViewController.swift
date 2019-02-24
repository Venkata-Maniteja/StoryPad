//
//  ViewController.swift
//  Wattpad_Test
//
//  Created by Venkata on 05/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import UIKit



class ViewController: UIViewController,AlertDisplayer {
    
    @IBOutlet weak var storyListView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    private var viewModel: StoryViewModel!
    private var spinner : Spinner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        showSpinner()
        
        viewModel = StoryViewModel(delegate: self)
        viewModel.fetchStories()
        
        customiseNavBar()
        prepareListView()
       
    }
    
    private func showSpinner(){
        spinner = Spinner.fromNib()
        spinner?.center = view.center
        view.addSubview(spinner!)
    }
    
    private func hidespinner(){
        spinner?.removeFromSuperview()
    }
    
    private func customiseNavBar(){
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    private func prepareListView(){
        let nib = UINib(nibName: "StoryCell", bundle: nil)
        storyListView.register(nib, forCellReuseIdentifier: Constants.cellForStory)
        storyListView.estimatedRowHeight = 70
        storyListView.prefetchDataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       viewModel.terminateAllDownloads()
    }
    
    deinit {
        viewModel.terminateAllDownloads()
    }
    

    /**
     This method is used in case the user scrolled into a set of cells that don't
     have their cover icons yet.
     */
    func loadImagesForOnscreenRows()
    {
        if viewModel.currentCount > 0
        {
            if let visiblePaths = storyListView.indexPathsForVisibleRows{
                for indexPath in visiblePaths{
                     let story = viewModel.story(at:indexPath.row)
                        if story.coverImg == nil{
                            // Avoid the app icon download if the app already has an icon
                           viewModel.startIconDownload(story.cover!, indPath: indexPath)
                        }
                    
                }
            }
        }
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let coverVc = segue.destination as! CoverViewController
        coverVc.story = sender as? Story
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }

}

extension ViewController : StoryViewModelDelegate{
   
    func onImageDownloaded(_ img: UIImage, _ indPath: IndexPath) {
        //Update the cell
        if let cell = self.storyListView.cellForRow(at: indPath) as? StoryCell{
            cell.storyIconView.image = img
        }
    }
    
    
    func onFetchCompleted(with stories: [Story]?) {
        DispatchQueue.main.async {
            self.hidespinner()
            self.storyListView.reloadData()
        }
    }
    
    func onFetchFailed(with reason: String) {
       // indicatorView.stopAnimating()
        
        let title = "Warning".localizedString
        let action = UIAlertAction(title: "OK".localizedString, style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
    
    func onStoriesFiltered() {
        self.storyListView.reloadData()
    }
    
    
}

extension ViewController : UIScrollViewDelegate{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate)
        {
            loadImagesForOnscreenRows()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnscreenRows()
    }
}

extension ViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.textDidChange(searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.searchDidStop(searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchDidStop(searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
   
   
}

extension ViewController : UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isSearchInProgress{
            return viewModel.filterCount
        }
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellForStory, for: indexPath) as! StoryCell
        
        var story : Story?
        if isLoadingCell(for: indexPath) {
            story = .none
            cell.configure(.none)
        } else {
            story = viewModel.story(at: indexPath.row)
            cell.configure(story)
        }
        
        if story?.coverImg == nil{
            if (self.storyListView.isDragging == false && self.storyListView.isDecelerating == false)
            {
                if let cover = story?.cover{
                    viewModel.startIconDownload(cover, indPath: indexPath)
                }
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let story = viewModel.story(at: indexPath.row)
        performSegue(withIdentifier: "showDetailStory", sender: story)
        
    }
    
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchStories()
        }
    }
}

private extension ViewController {
   
    /**
     This method takes the indexPath and checks if it is already loaded on screen
     or not by checking the indexPath with viewModel currentCount
     
     - Returns: true if cell is not loaded completely else false
     - Parameter indexPath: The indexPath of the cell
     
     */
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
   
}

