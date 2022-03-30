with Ada.Text_IO; use Ada.Text_IO;

with GNAT.Semaphores; use GNAT.Semaphores;

procedure Dinner_Philosophers is
   forks : array (1 .. 5) of Counting_Semaphore (1, Default_Ceiling);

   task type philosopher is
      entry set_id (id : in Integer);
   end philosopher;

   task body philosopher is
      id              : Integer;
      dinner_numbers  : Integer := 5;
      num_second_fork : Integer;
   begin
      accept set_id (id : in Integer) do
         philosopher.id := id;
      end set_id;
      num_second_fork := id rem 5 + 1;

      for i in 1 .. dinner_numbers loop
         if id < 5 then
            Put_Line ("philosopher" & id'Img & " thinking");
            forks (id).Seize;
            Put_Line ("philosopher" & id'Img & " await" & num_second_fork'img & " fork");
            forks (num_second_fork).Seize;

            Put_Line ("philosopher" & id'Img & " eating" & i'Img & " times");

            forks (num_second_fork).Release;
            forks (id).Release;
         else
            Put_Line ("philosopher" & id'Img & " thinking");
            forks (1).Seize;
            Put_Line ("philosopher" & id'Img & " wait" & id'Img & " fork");
            forks (5).Seize;
            Put_Line ("philosopher" & id'Img & " eating" & i'Img & " times");
            forks (5).Release;
            forks (1).Release;
         end if;
      end loop;
   end philosopher;

   philosophers : array (1 .. 5) of philosopher;
begin
   for i in philosophers'Range loop
      philosophers (i).set_id (i);
   end loop;
end Dinner_Philosophers;
