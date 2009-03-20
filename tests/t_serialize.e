include std/serialize.e
include std/unittest.e
include std/filesys.e

object FirstName = "Derek"
object LastName = "Parnell"
object PhoneNumber = 55551111
object Address = "1a High Street, Smallville"
object Balance = 1234.56

object rFirstName
object rLastName
object rPhoneNumber
object rAddress
object rBalance

sequence objcache
sequence res
integer pos

 objcache = serialize(FirstName) &
            serialize(LastName) &
            serialize(PhoneNumber) &
            serialize(Address) &
            serialize(Balance)

 pos = 1
 res = deserialize( objcache , pos)
 
 rFirstName = res[1] pos = res[2]
 test_equal("serialize #1.1", FirstName, rFirstName)
 
 res = deserialize( objcache , pos)
 rLastName = res[1] pos = res[2]
 test_equal("serialize #1.2", LastName, rLastName)
 
 res = deserialize( objcache , pos)
 rPhoneNumber = res[1] pos = res[2]
 test_equal("serialize #1.3", PhoneNumber, rPhoneNumber)
 
 res = deserialize( objcache , pos)
 rAddress = res[1] pos = res[2]
 test_equal("serialize #1.4", Address, rAddress)
 
 res = deserialize( objcache , pos)
 rBalance = res[1] pos = res[2]
 test_equal("serialize #1.5", Balance, rBalance)

 
 objcache = serialize({FirstName,
                      LastName,
                      PhoneNumber,
                      Address,
                      Balance})

 res = deserialize( objcache )
 rFirstName = res[1][1]
 rLastName = res[1][2]
 rPhoneNumber = res[1][3]
 rAddress = res[1][4]
 rBalance = res[1][5]
 
 test_equal("serialize #2.1", FirstName, rFirstName)
 test_equal("serialize #2.2", LastName, rLastName)
 test_equal("serialize #2.3", PhoneNumber, rPhoneNumber)
 test_equal("serialize #2.4", Address, rAddress)
 test_equal("serialize #2.5", Balance, rBalance)

 integer fh
 fh = open("cust.dat", "wb")
 puts(fh, serialize(FirstName))
 puts(fh, serialize(LastName))
 puts(fh, serialize(PhoneNumber))
 puts(fh, serialize(Address))
 puts(fh, serialize(Balance))
 close(fh)

 fh = open("cust.dat", "rb")
 rFirstName = deserialize(fh)
 rLastName = deserialize(fh)
 rPhoneNumber = deserialize(fh)
 rAddress = deserialize(fh)
 rBalance = deserialize(fh)
 close(fh)
 test_equal("serialize #3.1", FirstName, rFirstName)
 test_equal("serialize #3.2", LastName, rLastName)
 test_equal("serialize #3.3", PhoneNumber, rPhoneNumber)
 test_equal("serialize #3.4", Address, rAddress)
 test_equal("serialize #3.5", Balance, rBalance)

 fh = open("cust.dat", "wb")
 puts(fh, serialize({FirstName,
                     LastName,
                     PhoneNumber,
                     Address,
                     Balance}))
 close(fh)

 fh = open("cust.dat", "rb")
 res = deserialize(fh)
 close(fh)
 rFirstName = res[1]
 rLastName = res[2]
 rPhoneNumber = res[3]
 rAddress = res[4]
 rBalance = res[5]
 test_equal("serialize #4.1", FirstName, rFirstName)
 test_equal("serialize #4.2", LastName, rLastName)
 test_equal("serialize #4.3", PhoneNumber, rPhoneNumber)
 test_equal("serialize #4.4", Address, rAddress)
 test_equal("serialize #4.5", Balance, rBalance)


 object _ = delete_file("cust.dat")
test_report()
