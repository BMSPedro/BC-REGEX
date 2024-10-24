### POC (Proof of Concept)
Use global triggers and REGEX to format (control or relocate) all ERP fields based on a table of parameters.

# 1	Do you speak REGEX ?
![image](https://github.com/user-attachments/assets/0220cc8f-6eaa-44d7-ad7d-e285523c6249)

Definition of REGEX:
In computing, a regular expression or rational expression or normal expression or pattern is a character string which describes, according to a precise syntax, a set of possible character strings. (Source Wikipedia).

Whether we are fans or detractors of the concept, REGEX remains an effective tool for manipulating character strings. Operations such as search, modification or validation are extremely simplified.
There are an infinite number of examples of using REGEX on standardized strings such as emails, websites or telephone numbers. 
A concrete case would be to want to browse the variable declarations Sales Invoice Header, Sales Invoice Line, Sales Shipment Header and Sales Shipment Line in our famous Codeunit 80 Sales-Post.
Regex: :\sRecord\s("Sales)\s(Invoice|Shipment)\s(Header|Line)"
![image](https://github.com/user-attachments/assets/ffa11227-beea-412c-83f7-93ac9575fd11)

Difficult to obtain the same result by other means. ? 😉.

To practice this new language 🤣🤣: https://regex101.com/

# 2	REGEX in Business Central
The Dynamics Nav or Dynamics 365 Business Central solutions integrated, somewhat late, a technical layer on regular expressions (layer inherited from libraries on the same subject from .NET).
Very practical methods such as Ismatch, Match, Replace and Escape exist, super interesting no. ?
![image](https://github.com/user-attachments/assets/e7b61e5c-5de7-4dd7-a5a0-ddbbc4981ee6)

And functionally?
Nothing to my knowledge, despite the potential advantages cited above. 
(Apart from Continia’s Document Capture extension 😉).

A blatant Example of this functional void could be Business Central's approach to validating the structure of an email (Customer table), carried out by Codeunit 9520 "Mail Management" with the CheckValidEmailAddress(email) method:
![image](https://github.com/user-attachments/assets/154db0b7-e79a-45c1-919a-e90134b8603e)
🤔🤔😳…uuummhhh. (there is something similar for telephone numbers)

# 3 Our attempt
We wanted to release REGEX 😊 in Dynamics 365 Business Central by relying on the technical layer mentioned above. 
The first approach was to look at the fairly recent functionality (BC 2020 Wave 2, BC17) of Field Monitoring in Business Central which allows you to notify when a configurable field is modified in the ERP. An extension of this functionality would have allowed the same objects and routines to be used to trigger either the notification or an operation using REGEX for a field.
![image](https://github.com/user-attachments/assets/f4d03f59-9727-4d2f-b944-c62630a55c3d)
Problem., ☹
Most of these objects are marked internal, or non-extensible, an understandable choice in view of the security associated with functionality. On the other hand, an approach with interfaces would have made it possible to broaden the functional coverage of the use of REGEX.
![image](https://github.com/user-attachments/assets/6ef09242-5942-4ec8-a1ff-8292b3fa2e2a)

# 4 Our Extension
We ended up developing in a completely isolated way an extension supporting the use of REGEX (Matching control or character replacement), extremely simple and fast development, it is inspired by global triggers, in the same way as the Monitoring Fields functionality. It makes it possible to define an entry or replacement control pattern for any field in any table in our ERP.
![image](https://github.com/user-attachments/assets/a413bd9b-8fbf-4025-a7cc-71beb61e2682)
Main principal: Field regex Rules
![image](https://github.com/user-attachments/assets/390fc5d9-917a-42ea-8baa-e2ae8384da27)
Our Name 2 field should look like an email address.

For a field in a table it is possible to associate several rules (REGEX):
![image](https://github.com/user-attachments/assets/c27bcb84-7537-4415-af31-e9213d87ba1b)

Entering an incorrect value:
![image](https://github.com/user-attachments/assets/b28b4320-3ac5-4f88-8810-224dfd138dae)

Correct value:
![image](https://github.com/user-attachments/assets/e8cf80f1-4f50-4a79-9ccf-2173ba14e0b3)

This extension was produced only in experimental mode, to be improved and adapted to your context.  

# 5 BCIdeas
We submitted the idea to the Business Central team, if you find it useful, don't hesitate to take a look, comment or vote.
[https://experience.dynamics.com/ideas/idea/?ideaid=07654ff9-0d92-ef11-95f5-000d3a7dbfff]
![image](https://github.com/user-attachments/assets/61c6ea37-dd94-4bc0-a01d-4005a20ef0e7)















