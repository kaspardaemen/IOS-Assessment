

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var overviewLabel : UITextView!
    @IBOutlet weak var releaseLabel : UILabel!
    @IBOutlet weak var voteLabel : UILabel!
    @IBOutlet weak var posterLabel : UIImageView!
    @IBOutlet weak var watchTrailerButton : UIButton!
    var trailerUrl: String = "";
    
   
    

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        
        if let detail = self.detailItem {
            let movie  = detail as! Movie
            getTrailer(movie.id)
            self.title = movie.title
            
            if let overview = self.overviewLabel {
                overview.text = movie.description
            }
            
            if let release = self.releaseLabel {
                release.text = movie.release_date
            }
            if let vote = self.voteLabel {
                vote.text = String(movie.vote_average) + "/10"
            }
            if let poster = self.posterLabel {
                let url = NSURL(string: movie.post_path)
                let data = NSData(contentsOfURL: url!)
                poster.image = UIImage(data: data!)
                
            }
        }
    }
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
               
        // Do any additional setup after loading the view, typically from a nib.	
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PlayTrailer(sender: AnyObject) {       
        if let url = NSURL(string: self.trailerUrl){
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    func getTrailer(id : Int) {
        RestApiManager.sharedInstance.getTrailer(id) { json -> Void in
            
            
            
            let results : JSON = json["results"]
            
            for ( index, trailer ) in results {
                
                if trailer["type"] == "Trailer" {
                    self.trailerUrl = "https://www.youtube.com/watch?v="+String(trailer["key"])
                }
                
            }
        }
    }
    
//    for (int i = 0; i < jsonarray.length(); i++) {
//    
//    JSONObject obj = jsonarray.getJSONObject(i);
//    Log.d("LOGJE VAN KASPAR" ,obj.getString("type"));
//    if(obj.getString("type").equals("Trailer")){
//    trailer = true;
//    trailerUrl = "https://www.youtube.com/watch?v="+obj.getString("key");
//    }
//    }

    
    

}

