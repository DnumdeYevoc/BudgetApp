import 'package:flutter/material.dart';
import 'package:cheddar/ui_elements.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:provider/provider.dart';
import 'package:cheddar/user_provider.dart';

import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  bool selectedType = true;
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController categoryAmountController = TextEditingController();
  Icon categoryIcon = Icon(Icons.monetization_on);
  String categoryIconName = 'monetization_on';
  Future<void> _pickIcon() async {
    IconPickerIcon? result = await showIconPicker(
      context,
      
      configuration: SinglePickerConfiguration(
        showSearchBar: true,
        showTooltips: true,
        iconPackModes: [IconPack.material],
        
      ),
    );
    if (!mounted)return;

    if (result != null ){
        setState(() {
          categoryIcon = Icon(result.data);
          categoryIconName = result.name;
        });
      }
     else{
      setState(() {
      categoryIcon = Icon(Icons.monetization_on);
      categoryIconName = 'monetization_on';},
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final Budget budget = context.watch<UserProvider>().curBudget;
    return Scaffold(//add floating button
      appBar: AppBar(
        title: MyHeaderTitle(),
        actions: [
          IconButton(
            onPressed:(){print('pressed');}, 
            icon: Icon(Icons.add, 
            size: 40,
            color: Theme.of(context).colorScheme.onSurface,),
            alignment: Alignment.center,)
        ],
        ),
        
      floatingActionButton: FloatingActionButton(onPressed:(){
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                
                return Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left:20, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      Text('Add Category',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface
                        ),
                      ),
                
                      //exp or inc
                      SegmentedButton<bool>(
                        emptySelectionAllowed: false,
                        segments: const [
                          ButtonSegment<bool>(value: true, label: Text('Income')),
                          ButtonSegment<bool>(value: false, label: Text('Expense')),
                        ],
                        selected: {selectedType},
                        onSelectionChanged: (Set<bool> newSelection) {
                          setModalState(() {
                            selectedType = newSelection.first;
                          });
                        },
                      ),
                
                      Row(//name selector
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 30,
                        children: [
                          Text('Name'),
                          SizedBox(
                            width: 100,
                            height: 40,
                            child: TextField(//Category Name
                              
                              controller: categoryNameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                
                      Row(//budget amount selector
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 18,
                        children: [
                          Text('Amount'),
                          SizedBox(
                            width: 100,
                            height: 40,
                            child: TextField(//Category amount
                              keyboardType: TextInputType.number,
                              controller: categoryAmountController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(//pick Icon
                        spacing: 20,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Icon'),
                          IconButton(onPressed: (){_pickIcon();}, icon: categoryIcon, iconSize: 30),
                        ],
                      ),

                      ElevatedButton(
                        onPressed: (){//save all the values   
                          double val = double.tryParse(categoryAmountController.text)?? -1;
                          if (categoryNameController.text!= ''&& val!=-1 && val!= 0 ){                                                
                            context.read<UserProvider>().addCategory(
                              isInc: selectedType,
                              date: budget.budgetDate,
                              icon: categoryIcon,
                              iconName: categoryIconName,                            
                              name: categoryNameController.text,
                              value: val                          
                            );
                            Navigator.pop(context);
                          } else {
                            //add some sort of error?
                          }
                          
                        },
                        child: Text('Save')
                      ),
                      SizedBox(height:20),//spacer
                    ],
                  ),
                );
              },
            );
          },
        );
       

        },
        
        child: Icon(Icons.add),
        ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyPieChart(
                  innerData: budget.inc.values,
                  innerName: 'Income',
                  innerNameData: budget.inc.names,
                  innerIconData: budget.inc.icons,
                  outerData: budget.exp.values,
                  outerName: 'Expenses',
                  outerNameData: budget.exp.names,
                  outerIconData: budget.exp.icons,
                  radius: 10,
                ),
          MyCategoryList(names: budget.inc.names, icons: budget.inc.icons, values: budget.inc.values, showCurrentValues: false, isInc: true)
        ],
      ),
    );
  }
}