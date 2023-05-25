CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

cd student-submission

if [ ! -f ListExamples.java ] 
then 
    echo "FileNotFound Error: ListExamples.java is missing"
    exit 1 
fi 

cp ListExamples.java ../grading-area
cp ../TestListExamples.java ../grading-area

cd ../lib 

cp hamcrest-core-1.3.jar ../grading-area
cp junit-4.13.2.jar ../grading-area

cd ../grading-area

javac -cp .:hamcrest-core-1.3.jar:junit-4.13.2.jar *.java
java -cp .:hamcrest-core-1.3.jar:junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples


if [ $? -ne 0 ] 
then
    echo "Did Not Compile"
    exit 1 
fi 

output=$(java -cp .:hamcrest-core-1.3.jar:junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples)

if [ $output == "FAILURES!!!" ] 
then 
    echo "Did Not Pass Tests"
    exit 1 
fi

tests=$(grep "Tests run: \K[0-9]+" <<< "$output")
testsP=$(grep "Tests run: [0-9]+, Failures: \K[0-9]+" <<< "$output")

if [ tests != 0 ]
then
score=$(awk -v testsP="$testsP" -v tests="$tests" 'BEGIN {print testsP / tests * 100}')
fi 

echo "Grade: $score%"
