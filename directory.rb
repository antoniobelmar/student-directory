#this declares the variables available to all methods
@students=[]
  #this is a hash of cohort months and symbols
@cohort_list={:january=>"january",
             :february=>"february",
             :march=>"march",
             :april=>"april",
             :may=>"may",
             :june=>"june",
             :july=>"july",
             :august=>"august",
             :september=>"september",
             :october=>"october",
             :november=>"november",
             :december=>"december"
             }

#this provides an interactive menu to start our program
def interactive_menu
  #keep giving options for the user to choose what s/he wants to do
  loop do
    #print the menu to ask the student what he wants to do
    print_menu
    #execute the user's requested action
    process(STDIN.gets.chomp)
  end
end

#this method prints the all user's possible options while using the interactive_menu
def print_menu
  puts "What would you like to do?"
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list to a file"
  puts "4. Load the list a file"
  puts "9. Exit"
end

#this method establishes what happens when user selects a specific option
def process(selection)
  puts "You've chosen option #{selection}"
  puts
  case selection
  when "1"
    #input the students
    input_students
  when "2"
    #show the students
    show_students
  when "3"
    #save the students to the .csv file
    save_students
  when "4"
    #load students from the .csv file
    load_students
  when "9"
    #exit the program
    exit
  else
    puts "I can't recognize this option, please try again:"
  end
  if selection.to_i.between?(1,8)
    puts "Your choice was successfully carried out."
    puts
  end
end

#this method allow for the creation of the student list database by asking the user for input and storing it in an array and hashes
def input_students
  puts "Please enter the name of the students."
  puts "To finish, just press \"return\" twice (or once if you don't want to add any students ;))"
  #now we start getting the list of students from the user asking for the first name
  #we are using the method delete to delete the return character at the end of user's input
  name= STDIN.gets.delete("\n")
  #we use a loop to collect all names until the input is empty
    while !(name.empty?)
      #first we ask for the cohort
      puts "Which cohort does #{name} come from?"
      cohort=STDIN.gets.chomp
      #now we check if that cohort exists in our compiled hash of cohorts, if not, we keep asking for a cohort until it does
          while !(@cohort_list.has_value?(cohort.downcase))
            puts "Oops, we cannot recognize that cohort, do you want to try again?"
            cohort=STDIN.gets.chomp
          end
          #now we add the inputted name to the array via a hash (together with a cohort, hobbies and country)
          add_student_info(name,cohort)
          #then we say how many students we now have
          if @students.count==1
            puts "Now we have #{@students.count} student."
          else
            puts "Now we have #{@students.count} students."
          end
          #we then ask for a new student name from the user and change the variable name restarting the loop
          name=STDIN.gets.chomp
    end
end

#this method simply adds the student information collected from another method to the @students variable
def add_student_info(name,cohort)
  @students.push({:name=>name.capitalize, :cohort=>@cohort_list.key(cohort.downcase), :hobbies=>"killing people", :country=>"Hell"})
end

#this method prints all students to the screen with a header and footer
def show_students
  print_header
  print_student_list
  print_footer
end

#this method prints the heading of the student list
def print_header
  #added an if statement to only print if the list has at least one student name
  if !(@students.empty?)
    #we use the center method to make the header centered
    puts "The students of Villains Academy".center(100)
    puts "".center(100,"-")
  else
    puts "The student list is empty! There is nothing to print."
  end
end

#this method prints the students names and cohorts
def print_student_list
  i=0
  #we are now using a loop to print the name of each student
  while i<@students.count
      puts "#{i+1}. #{@students[i][:name]} (#{@students[i][:cohort]} cohort). #{@students[i][:name]}\'s main hobby is #{@students[i][:hobbies]}.".center(100)
      i+=1
  end
  puts
end

#this method prints the footer of the student list which includes the current student count.
def print_footer
  unless @students.count==0
    print "Overall, we have #{@students.count} great students but we are only printing "
    puts "the ones according to your specifications."
    puts
  end
end

#this method saves the student list to a .csv file
def save_students
  #ask for a file name
  puts "Which file name would you like to use to save your information?"
  file_name=STDIN.gets.chomp
  #open the file for writing
  require "csv"
  CSV.open(file_name,"w") do |file|
  #then we iterate over the array of students
    @students.each do |student|
      #we create an array with the information we need
      student_data=[student[:name],student[:cohort]]
      #we call puts on our file so that we can puts the information onto the file rather than to our screen
      file.puts student_data
    end
  end
end

#this method loads the list of students from the previously saved .csv file
def load_students(passed_filename=nil)
  puts "Which file would you like to load your list from?"
  file_name=STDIN.gets.chomp
  if File.exists?(file_name)
    require "csv"
    CSV.foreach(file_name) do |line|
      name=line[0]
      cohort=line[1]
      #we then run the add_student_info method which allows to store information from students into our @student variable
      add_student_info(name,cohort)
    end
  else
    puts "This file does not exist. Let's take you to the menu!!"
  end
end

#this method tries to load any file to the student list from the get go
def try_load_students
  #first we see if there was a filename passed as an argument on the command line
  filename=ARGV.first
  if filename.nil?
    load_students
    #if a filename was passed we need to check if the file exists or we could just get an error message
  elsif File.exists?(filename)
    #if the file exists use method load students (which allows to load student data from any file)
    load_students(filename)
    puts "Loaded #{@students.count} students from #{filename}."
  else
    puts "Sorry, #{filename} does not exist." #if the file does not exist simply print an error message and leave the program
    exit
  end
end

#the following methods are not our the main methods in our program but we can refer to them if necessary

#this method prints the students names by cohort
def print_list_cohort(students)
  i=0
  #we create an empty array to get store a list of all existing cohorts
  arr=[]
  #we are now using a loop to find all existing cohorts
  while i<students.count
      arr.push(students[i][:cohort])
      i+=1
  end
  #we eliminate double cohorts from our array so that we can iterate over it and not have duplicates
  arr.uniq.each do |month|
    #we puts every month as a title
    puts "#{month.capitalize}:".center(100)
    puts
    #we then iterate over the students list fo find print only the students from that cohort
      students.each do |student|
        if student[:cohort]==month
          puts "#{student[:name]}. #{student[:name]}\'s main hobby is #{student[:hobbies]}."
          puts
        end
      end
  end
end

#this method prints the students names and cohorts according to some restrictions
def print_list_letter(students)
  puts "You want to see students' names starting with which letter?"
  letter=gets.chomp
  students.each do |student|
    #only print students whose first letter of the name is the same as specified letter
    if student[:name][0].downcase==letter
      puts "#{student[:name]} (#{student[:cohort]} cohort)"
    end
  end
end

#this method prints the students names and cohorts according to some restrictions
def print_list_size(students)
  size=12
  students.each do |student|
    #only print students whose total name (including spaces) is shorter than 12 characters
    if student[:name].length<=size
      puts "#{student[:name]} (#{student[:cohort]} cohort)"
    end
  end
end

#this method displays all the code in the current file
def read_source_code
  File.open($0,"r") do |file|
    puts file.read
  end
end

read_source_code
try_load_students
interactive_menu
