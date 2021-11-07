import pandas as pd
bankdata=pd.read_csv('loan_data.csv')
bankdata.info()
cat_feat=['purpose']
final_data=pd.get_dummies(bankdata,columns=cat_feat,drop_first=True)
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(final_data.drop('not.fully.paid',axis=1),final_data['not.fully.paid'], test_size=0.3, random_state=0)
from sklearn.tree import DecisionTreeClassifier
dtree=DecisionTreeClassifier()
dtree.fit(X_train,y_train)
predict=dtree.predict(X_test)
from sklearn.metrics import classification_report,confusion_matrix
print(classification_report(y_test,predict))
print(confusion_matrix(y_test,predict))


