//
//  ViewController.swift
//  CoverPage
//
//  Created by Venkata Nandamuri on 12/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//



import UIKit

class CoverViewController: UIViewController {
    
    @IBOutlet weak var tblView : UITableView!
    var headerView : UIImageView?
    var blurV : UIVisualEffectView?
    
    var avatarView : UIView?
    var headerHeight = 200
    var avatarFrame = CGRect(x: 20, y: 270, width: 60, height: 60)
    
    var story : Story? = Optional.none
    
    var loveArray = ["Love is like the wind, you can't see it, but you can feel it.","Love is that condition in which the happiness of another person is essential to your own","In dreams and in love, there are no impossibilities.","Love is the hardest habit to break and the most difficult to satisfy.","Love is a game that two can play and both win.","Love always brings difficulties, that is true, but the good side of it is that it gives energy.","Absence sharpens love, presence strengthens it.","Soul mates. It's extremely rare, but it exists. It's sort of like twin souls tuned into each other.","Love is a little world; people make it big.","Love without reason lasts the longest.","You always gain by giving love.","All that you are is all that I’ll ever need.","We are most alive when we're in love.","The heart has its reasons of which reason knows nothing.","You can't blame gravity for falling in love.","If you find someone you love in your life, then hang on to that love.","I think I'd miss you even if we never met.","I fell in love the way you fall asleep: slowly, and then all at once.","A simple \("I love you") means more than money.","Everything I do, I do it for you.","You don't marry someone you can live with — you marry someone you cannot live without.","There is only one happiness in this life, to love and be loved."]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        customiseNavBar()
        prepareListView()
        addHeaderView()
        addAvatarView()
        
    }
    
    private func prepareListView(){
        tblView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblView.backgroundColor = UIColor.clear
        tblView.contentInset = UIEdgeInsets(top: CGFloat(headerHeight), left: 0, bottom: 100, right: 0)
    }
    
    private func customiseNavBar(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func addHeaderView(){
        headerView = UIImageView()
        if let coverImg = story?.coverImg{
            headerView?.image = coverImg
        }else{
            headerView?.image = UIImage(named: "Rups")
        }
        headerView!.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: headerHeight)
        headerView!.contentMode = .scaleAspectFit
        headerView!.clipsToBounds = true
        
        blurV = UIVisualEffectView(frame: headerView!.frame)
        blurV!.effect = UIBlurEffect(style: .light)
        blurV?.tintColor = UIColor.orange
        blurV?.backgroundColor = UIColor.orange
        view.addSubview(blurV!)
        view.addSubview(headerView!)
    }
    
    private func addAvatarView(){
        avatarView = UIView(frame: avatarFrame)
        let imgV = UIImageView(frame: avatarView!.bounds)
        imgV.contentMode = .scaleAspectFit
        imgV.image = UIImage(named: "icons8-heart-outline-96")
        imgV.clipsToBounds = true
        imgV.layer.cornerRadius = imgV.frame.size.width/2
        
        if let userIcon = story?.user?.avatar{
            loadAsyncImg(userIcon)
        }
        
        avatarView?.layer.borderColor = UIColor.orange.cgColor
        avatarView?.layer.borderWidth = 2.0
        avatarView?.layer.cornerRadius = 30
        avatarView?.layer.shadowColor = UIColor.black.cgColor
        avatarView?.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        avatarView?.layer.shadowOpacity = 0.4
        avatarView?.layer.shadowRadius = 4.0
        avatarView?.addSubview(imgV)
        view.addSubview(avatarView!)
        view.bringSubviewToFront(avatarView!)
    }
    
    func updateHeaderView(){
        
        let y = -tblView.contentOffset.y
        let height = min(max(y, 60), 400)
        headerView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        blurV?.frame = headerView!.frame
        
        avatarFrame = CGRect(x: 20, y: max(y - 30,30), width: 60, height: 60)
        avatarView?.frame = avatarFrame
    }
    
    func loadAsyncImg(_ imgURL : String) {
        
        guard let url = URL(string:imgURL) else{
            return
        }
        let downloader = IconDownloader(url)
        downloader.completionHandler = { img in
            DispatchQueue.main.async {
                let imgV = self.avatarView?.subviews[0] as! UIImageView
                imgV.image = img
            }
        }
        downloader.startDownload()
       
    }
    
}

extension CoverViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loveArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        customiseCell(cell, indexPath)
        return cell
        
    }
    
    private func customiseCell(_ cell : UITableViewCell,_ indexPath : IndexPath){
        cell.textLabel?.text = loveArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.textColor = UIColor.darkGray//UIColor(red: 1.0, green: 0.22, blue: 0.58, alpha: 1.0)//colorWithRed:1.00 green:0.22 blue:0.58 alpha:1.0
        cell.textLabel?.font = UIFont(name: "Cochin-Italic", size: 16)
        
        cell.backgroundColor = UIColor.clear
    }
    
    
    
}


extension CoverViewController : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("scrolled to top")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("begin draggin")
    }
}
