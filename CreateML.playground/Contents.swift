import CreateML
import Foundation

let trainingDir = URL(fileURLWithPath: "/Users/zhaxu/Downloads/fruit-images-for-object-detection/train")

let testDir = URL(fileURLWithPath: "/Users/zhaxu/Downloads/fruit-images-for-object-detection/test")

let model = try MLImageClassifier(trainingData: .labeledDirectories(at: trainingDir))

let evaluation = model.evaluation(on: .labeledDirectories(at: testDir))

try model.write(to: URL(fileURLWithPath: "/Users/zhaxu/Desktop/FruitsModel"))
