int main(int argc, char* argv[])
{
  fwhile (!cin.eof())
  {
    char buf[4];
    cin.getline(buf, 4);
    cout << setfill('0')  << setw(8) <<  hex << buf[0] << buf[1] << buf[2] << buf[3] << '\n';
  }
  return 0;
}
