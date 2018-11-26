import CreateML
import Foundation

let trainingDir = URL(fileURLWithPath: "/Users/zhaxu/Downloads/training")

let testDir = URL(fileURLWithPath: "/Users/zhaxu/Downloads/testing")

let model = try MLImageClassifier(trainingData: .labeledDirectories(at: trainingDir))

let evaluation = model.evaluation(on: .labeledDirectories(at: testDir))

try model.write(to: URL(fileURLWithPath: "/Users/zhaxu/Desktop/AnimalsModel"))
