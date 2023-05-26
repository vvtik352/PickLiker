
import UIKit

struct APIKeys {
    static let APIKey = "TPqu0Sf-TivvpyzvYZa8ejGVst6UWSWkNYSBBDdmIoM"
}

struct Photo: Codable {
    let urls: Urls
}
struct Urls: Codable {
    let regular: String
    var regularUrl: URL {
        return URL(string: regular)!
    }
}

class ImageLoaderController: UITableViewController {
    var photos = [Photo]()

    override func viewDidLoad() {
        print("loading ")
        super.viewDidLoad()
        print("loaded ")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Photo")

        fetchPhotos()
    }

    func fetchPhotos() {
        let urlString = "https://api.unsplash.com/photos/?client_id=\(APIKeys.APIKey)&order_by=latest&per_page=30"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                return
            }

            guard let data = data else { return }

            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                self.photos = photos
                print("ooo'",photos)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let jsonError {
                print("jsonError", jsonError)
            }
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath)

       let imageName = URL.init(string:  photos[indexPath.row].urls.regular)

       getData(from: imageName!) { data, response, error in
           guard let data = data, error == nil else { return }
           print(response?.suggestedFilename ?? imageName!.lastPathComponent)
           print("Download Finished!")
           
           DispatchQueue.main.async() { [weak self] in
                          var cellImageLayer: CALayer?  = cell.imageView?.layer
                          cellImageLayer!.masksToBounds = true
               cell.imageView!.image = UIImage(data: data)
           }
       }
       return cell
    }
}

func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}

class PhotoCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    func configure(with url: String?) {
        guard let urlString = url, let imageUrl = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
        task.resume()
    }
}

func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{


    var scale = CGFloat(max(size.width/image.size.width,
        size.height/image.size.height))
    var width:CGFloat  = image.size.width * scale
    var height:CGFloat = image.size.height * scale;

    var rr:CGRect = CGRectMake( 0, 0, width, height);

    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    image.draw(in: rr)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    return newImage!
}
