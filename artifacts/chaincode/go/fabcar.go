package main

import (
	"encoding/json"
	"fmt"

	//"strconv"
	"time"

	"github.com/golang/protobuf/ptypes"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type SmartContract struct {
	contractapi.Contract
}

type Student struct {
	Name        string `json:"name"`
	Reg         string `json:"reg"`
	Dept        string `json:"dept"`
	School      string `json:"school"`
	Year        string `json:"year"`
	CGPA        string `json:"cgpa"`
	LetterGrade string `json:"lettergrade"`
	Distinction string `json:"distinction"`
	ImgURL      string `json:"imgurl"`
}

type QueryResult struct {
	Key    string `json:"Key"`
	Record *Student
}

type HistoryQueryResult struct {
	Record *Student `json:"record"`
	//TxId     	string    	`json:"txId"`
	Timestamp time.Time `json:"timestamp"`
	IsDelete  bool      `json:"isDelete"`
}

func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	students := []Student{
		{
			Name:        "Ashraf Tasin",
			Reg:         "2017331014",
			Dept:        "CSE",
			School:      "ASE",
			Year:        "2022",
			CGPA:        "3.81",
			LetterGrade: "A",
			Distinction: "YES",
			ImgURL:      "dummy",
		},
		{
			Name:        "Joy Dip Das",
			Reg:         "2017331064",
			Dept:        "CSE",
			School:      "ASE",
			Year:        "2022",
			CGPA:        "3.80",
			LetterGrade: "A",
			Distinction: "YES",
			ImgURL:      "dummy",
		},
		{
			Name:        "Dummy",
			Reg:         "2017331000",
			Dept:        "CSE",
			School:      "ASE",
			Year:        "2022",
			CGPA:        "4.00",
			LetterGrade: "A+",
			Distinction: "YES",
			ImgURL:      "dummy",
		},
	}

	for _, student := range students {
		studentAsBytes, _ := json.Marshal(student)

		err := ctx.GetStub().PutState(student.Reg, studentAsBytes)

		if err != nil {
			return fmt.Errorf("failed to put to world state. %s", err.Error())
		}
	}

	return nil
}

func (s *SmartContract) AddStudent(ctx contractapi.TransactionContextInterface, name string, reg string, dept string, school string, year string, cgpa string, lettergrade string, distinction string, imgurl string) error {

	student := Student{
		Name:        name,
		Reg:         reg,
		Dept:        dept,
		School:      school,
		Year:        year,
		CGPA:        cgpa,
		LetterGrade: lettergrade,
		Distinction: distinction,
		ImgURL:      imgurl,
	}

	studentAsBytes, err := json.Marshal(student)

	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(reg, studentAsBytes)
}

func (s *SmartContract) QueryStudent(ctx contractapi.TransactionContextInterface, reg string) (*Student, error) {

	studentAsBytes, err := ctx.GetStub().GetState(reg)

	if err != nil {
		return nil, fmt.Errorf("failed to read from world state. %s", err.Error())
	}

	if studentAsBytes == nil {
		return nil, fmt.Errorf("%s does not exist", reg)
	}

	student := new(Student)
	_ = json.Unmarshal(studentAsBytes, student)

	return student, nil
}

// func (s *SmartContract) QueryAllCars(ctx contractapi.TransactionContextInterface) ([]QueryResult, error) {
// 	startKey := "CAR0"
// 	endKey := "CAR99"

// 	resultsIterator, err := ctx.GetStub().GetStateByRange(startKey, endKey)

// 	if err != nil {
// 		return nil, err
// 	}
// 	defer resultsIterator.Close()

// 	results := []QueryResult{}

// 	for resultsIterator.HasNext() {
// 		queryResponse, err := resultsIterator.Next()

// 		if err != nil {
// 			return nil, err
// 		}

// 		car := new(Car)
// 		_ = json.Unmarshal(queryResponse.Value, car)

// 		queryResult := QueryResult{Key: queryResponse.Key, Record: car}
// 		results = append(results, queryResult)
// 	}

// 	return results, nil
// }

// func (s *SmartContract) ChangeCarOwner(ctx contractapi.TransactionContextInterface, carNumber string, newOwner string) error {
// 	car, err := s.QueryCar(ctx, carNumber)

// 	if err != nil {
// 		return err
// 	}

// 	car.Owner = newOwner

// 	carAsBytes, _ := json.Marshal(car)

// 	return ctx.GetStub().PutState(carNumber, carAsBytes)
// }

func (s *SmartContract) GetStudentHistory(ctx contractapi.TransactionContextInterface, reg string) ([]HistoryQueryResult, error) {
	//log.Printf("GetAssetHistory: ID %v", assetID)

	resultsIterator, err := ctx.GetStub().GetHistoryForKey(reg)
	if err != nil {
		return nil, err
	}

	defer resultsIterator.Close()

	var records []HistoryQueryResult

	for resultsIterator.HasNext() {
		response, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		var student Student

		if len(response.Value) > 0 {
			err = json.Unmarshal(response.Value, &student)
			if err != nil {
				return nil, err
			}
		} else {
			student = Student{
				Reg: reg,
			}
		}

		timestamp, err := ptypes.Timestamp(response.Timestamp)
		if err != nil {
			return nil, err
		}

		record := HistoryQueryResult{
			//TxId:      response.TxId,
			Timestamp: timestamp,
			Record:    &student,
			IsDelete:  response.IsDelete,
		}
		records = append(records, record)
	}

	return records, nil
}

func main() {

	chaincode, err := contractapi.NewChaincode(new(SmartContract))

	if err != nil {
		fmt.Printf("Error create smartcert chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting smartcert chaincode: %s", err.Error())
	}
}
