
import UIKit

class PreferenceControler : UIViewController {
    @IBOutlet weak var pageValue :UILabel?
    @IBOutlet weak var stepper : UIStepper?
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configView()
        
    }
    
    func configView()
    {
        if let labelValue =  defaults.stringForKey("pageValue") {
            pageValue!.text = String(labelValue)
            stepper?.value = Double(labelValue)!
        }
    }
    
    @IBAction func stepperAction(sender: AnyObject) {
        if let label = self.pageValue {
            let value : Int = Int((stepper?.value)!)
            label.text = String(value)
            
            defaults.setInteger(value, forKey: "pageValue")
        }
       
        
    }
 
    
}