defmodule(GenCourses) do

  def write_courses(name) do
    {:ok, res} = File.open(name, [:write, :utf8])
    classes = gen_classes()
    clist = gen_courses(classes, [])
    write_course_list(clist, res)
    File.close(res)
  end

  def gen_subjects() do
    [ "ENGL", "PHIL", "ENGR", "HORT", "ASTRO" ]
  end

  def gen_levels() do
    [ "101", "110", "201", "210", "301", "310", "401", "455" ]
  end

  def gen_room() do
    "B" <> Integer.to_string(:random.uniform(10))
  end

  def gen_classes() do
    for s <- gen_subjects(), l <- gen_levels(), do: { s, l }
  end

  def gen_courses([], courses) do
    Enum.sort(courses, &(elem(&1, 0) <= elem(&2, 0)))
  end

  def gen_courses([{ subject, level } |rest], course) do
    gen_courses(rest, [ { gen_id(), subject, level, gen_room() } | course ])
  end

  def gen_id() do
    :random.uniform(1000)
  end

  def write_course_list([], res) do
    {:ok, res}
  end
 
  def write_course_list([{id, name, number, room} | t], res) do
    IO.write(res, "#{id},#{name},#{number},#{room}\n")
    write_course_list(t, res)
  end

end
