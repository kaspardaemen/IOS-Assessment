
import UIKit

class TheaterViewController: UITableViewController {
    var detailViewController: DetailViewController? = nil
    var movies = [Movie]()
    let defaults = NSUserDefaults.standardUserDefaults()
    var nPages: Int = 1;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let pageValue = defaults.stringForKey("pageValue"){
            switch pageValue {
            case "40":
                nPages = 2
            case "60":
                nPages = 3
            case "80":
                nPages = 4
            default:
                nPages = 1
            }
        }
        for index in 1...nPages {
            getMovies(index)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        //        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
    }
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(sender: AnyObject) {
        self.movies.append(sender as! Movie)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let movie = movies[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = movie
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies	.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let movie = movies[indexPath.row]
        let url = NSURL(string: movie.post_path)
        let data = NSData(contentsOfURL: url!)
        
        cell.textLabel!.text = movie.title
        cell.imageView?.image = UIImage(data: data!)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            movies.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func getMovies(page : Int) {
        
               
        RestApiManager.sharedInstance.getMovies (Tab.Theater, page: page) { json -> Void in
            let results : JSON = json["results"]
            
            for ( index, movie ) in results {
                
                let genres: AnyObject = movie["genre_ids"].object
               
                self.movies.append(Movie(id: movie["id"].int!,title: movie["title"].string!, description: movie["overview"].string!, genre: Genre.Action,poster_path: movie["poster_path"].string!, release_date: movie["release_date"].string!, vote_average: movie["vote_average"].double!))
                            }
        }
    }

}
