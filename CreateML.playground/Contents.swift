import CreateML
import Foundation

let trainingDir = URL(fileURLWithPath: "/Users/zhaxu/Downloads/Datasets/flower-color-images/Training")

let testDir = URL(fileURLWithPath: "/Users/zhaxu/Downloads/Datasets/flower-color-images/Testing")

let model = try MLImageClassifier(trainingData: .labeledDirectories(at: trainingDir))

let evaluation = model.evaluation(on: .labeledDirectories(at: testDir))

try model.write(to: URL(fileURLWithPath: "/Users/zhaxu/Desktop/Model"))
